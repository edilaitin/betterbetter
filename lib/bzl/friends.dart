#include <stdlib.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include <readline/readline.h>
#include <readline/history.h> 
#include <unistd.h>
#include <sys/wait.h>

#define MAX_COMMANDS 50
#define MAX_PARAMS 15

char ***get_input(char *);

int spawn_proc (int in, int out, char ***comands)
{
  pid_t pid;

  if ((pid = fork ()) == 0)
    {
      if (in != 0)
        {
          dup2 (in, 0);
          close (in);
        }

      if (out != 1)
        {
          dup2 (out, 1);
          close (out);
        }

      return execvp (comands[0][0], (char * const *)comands[0]);
    }

  return pid;
}

int fork_pipes (int n, char ***comands)
{
  int i;
  pid_t pid;
  int in, fd [2];

  /* The first process should get its input from the original file descriptor 0.  */
  in = 0;

  /* Note the loop bound, we spawn here all, but the last stage of the pipeline.  */
  for (i = 0; i < n - 1; ++i)
    {
      pipe (fd);

      /* f [1] is the write end of the pipe, we carry `in` from the prev iteration.  */
      spawn_proc (in, fd [1], comands + i);

      /* No need for the write end of the pipe, the child will write here.  */
      close (fd [1]);

      /* Keep the read end of the pipe, the next child will read from there.  */
      in = fd [0];
    }

  /* Last stage of the pipeline - set stdin be the read end of the previous pipe
     and output to the original file descriptor 1. */  
  if (in != 0)
    dup2 (in, 0);

  /* Execute the last stage with the current process. */
  return execvp (comands[i][0], (char * const *)comands[i]);
}

int getNrCommands(char ***commands) 
{
    for(int nr = 0; nr < MAX_COMMANDS; nr++)
    {
        if(commands[nr][0][0] == '\0')
           return nr;
    }
}

int main() {
    char ***commands;
    char *input;
    pid_t child_pid;
    int stat_loc;
    int c;

    while (1) {
        input = readline("\n>");
        add_history(input); 
        commands = get_input(input);
        
        while ((c = getopt (MAX_COMMANDS, commands[0], "ls:")) != -1)
        {
            printf("%c\n", c);
        }
        
        int numCommands = getNrCommands(commands);

        child_pid = fork();
        if (child_pid < 0) {
            perror("Fork failed");
            exit(1);
        }

        if (child_pid == 0) {
            fork_pipes(numCommands, commands);
            exit(1);
            
        } else {
            waitpid(child_pid, &stat_loc, WUNTRACED);
        }

        free(input);
        free(commands);
    }

    return 0;
}


void trimSpaces(char * s) {
    char * p = s;
    int l = strlen(p);

    while(isspace(p[l - 1])) p[--l] = 0;
    while(* p && isspace(* p)) ++p, --l;

    memmove(s, p, l + 1);
} 

char ***get_input(char *input) {
    char ***commands;
    commands = calloc(MAX_COMMANDS, sizeof(char**));

    for(int z = 0; z < MAX_COMMANDS; z++) 
    { 
        commands[z] = calloc(MAX_COMMANDS, sizeof(char*));
        for(int i = 0; i < MAX_COMMANDS; i++) 
        {
            commands[z][i] = calloc(MAX_COMMANDS, sizeof(char));
        }
    }
    
    if (commands == NULL) {
        perror("malloc failed");
        exit(1);
    }
    
    char *pipeSeparator = "|";
    char *pipeParsed;
    
    char *spaceSeparator = " ";
    char *spaceParsed;
    
    int pipeIndex = 0;
    
    while((pipeParsed = strsep(&input, pipeSeparator)) != NULL) {
        int index = 0;
        trimSpaces(pipeParsed);
        while ((spaceParsed = strsep(&pipeParsed, spaceSeparator)) != NULL) {
            commands[pipeIndex][index] = spaceParsed;
            index++;
        }
        commands[pipeIndex][index] = NULL;
        pipeIndex++;
    }

    return commands;
}
