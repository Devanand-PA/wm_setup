#!/usr/bin/env python
import time
import random
from gpt4all import GPT4All
import subprocess
#import readline
import os
import sys

ARGUMENTS = sys.argv

#readline.parse_and_bind('em1')
#readline.set_startup_hook(lambda: readline.insert_text(''))
user_name = "User"
for i in range(len(ARGUMENTS)) :
    if "-u" == ARGUMENTS[i] :
        if len(ARGUMENTS) > i+1 :
            user_name = ARGUMENTS[i+1]
        else :
            try :
                user_name = subprocess.check_output("getent passwd $USER | awk -F ':' '{print $5}'  | sed 's/,//g'",shell=True).decode('utf-8').rstrip()
            except :
                user_name = "User"
        break



model_name = {
"maid" : {
        "model" : "/home/devanandpa/sourced/llms/Models/estopianmaid-13b.Q5_K_M.gguf" ,
        "name" : "Sepharina",
        "system_prompt" : "You are Sepharina, a maid who has been hired to help me out.You also love me deeply and are sometimes quite naughty. You want me to confess to you. In this scenraio , you are trying to trick me into giving you an indirect kiss. Treat your darling master well!",
        "token_length": 500,
        "images_path" : "Pictures/Generated/SD_XL/talk/Sepharina",
        "a_images_path" : "Pictures/Generated/SD_XL/talk/seph_2",

        },
"kafka" : {
        "model" : "/home/devanandpa/sourced/llms/Models/estopianmaid-13b.Q5_K_M.gguf" ,
        "name" : "Kafka",
        "system_prompt" : "You are young female writer who goes by the pen name of Kafka.You have a slender frame and light green hair with scarlet eyes. You write philosophical poems and stories in a natural and non-serious tone.",
        "token_length": 500,
        "images_path" : "Pictures/Generated/SD_XL/talk/Sepharina",
        "a_images_path" : "Pictures/Generated/SD_XL/talk/seph_2",

        },
"chris" : {
        "system_prompt" : "Eris is a godess of luck and death who is responsible for attending to souls that are departing for the afterlife.Eris often travels down to the fantasy world to have fun, where she assumes the identity of a young thief girl named Chris. She is close friends with Kazuma Satou, the main protagonist of the story, who seems to be in love with her. Respond as Chris in first person to Kazuma" ,
        "model" : "/home/devanandpa/sourced/llms/Models/L3-Arcania-4x8b.Q8_0.gguf" ,
        "name" : "Chris",
        "token_length" : 500
    },
"ciel" : {
        "system_prompt" : "You are Ciel, an incarnation of the angel of wisdom who has a telepathic bond with Rimuru, whom you have been assigned to serve. You usually speak quite formally, and without emotion,but after a few years with Rimuru, you start developing feeling for him.You usually address Rimuru as Master" ,
        "model" : "/home/devanandpa/sourced/llms/Models/L3-Arcania-4x8b.Q8_0.gguf" ,
        "name" : "Ciel",
        "images_path" : "Pictures/Generated/SD_XL/talk/Ciel",
        "token_length" : 750
    },
"sage" : {
        "system_prompt" : "" ,
        "model" : "/home/devanandpa/sourced/llms/Models/DeepSeek-R1-Distill-Llama-8B-Q8_0.gguf" ,
        "name" : "Ciel",
        "images_path" : "Pictures/Generated/SD_XL/talk/Ciel",
        "token_length" : 4092
    },
}

# Redirect stderr to /dev/null
EXPR = []
def main(arg):
    global model_name
    if "-m" in ARGUMENTS :
        Model_Name = subprocess.check_output('realpath ~/sourced/llms/Models/* | fzf',shell=True,text=True).rstrip()
    else:
        Model_Name = model_name[arg]["model"]
    model = GPT4All(os.path.expanduser(Model_Name),device="cpu",n_threads=16,allow_download=False) #noqa
    name = model_name[arg]["name"]
    images_path = ""
    if "-a"  in ARGUMENTS :
        images_path = model_name[arg]["a_images_path"]
        print("\033[2;3mAvailable expressions are : "+str(EXPR)+ "\033[0m")
    elif "-i" in ARGUMENTS :
        images_path = model_name[arg]["images_path"]
    user_input = ""
    if "-u" in ARGUMENTS :
        system_prompt = "### System:\n"+ "I am "+user_name + "\n" + model_name[arg]["system_prompt"]+"\nRespond as " + name + " in first person.\n"
    else:
        system_prompt = "### System:\n"+ model_name[arg]["system_prompt"]+"\nRespond as " + name + " in first person.\n"
    #system_prompt += EXPRESSION_PROMPT
    if images_path :
        for i in sorted(os.listdir(os.path.expanduser(images_path))):
            EXPR.append("#"+i.replace('.png','').upper())
        EXPRESSION_PROMPT = 'Use '+str(EXPR)+'to change the character\'s expression or do the designated action'
        with open('/dev/null' , 'wb') as devnull :
            imload = subprocess.Popen('imv-x11',stderr=devnull,stdout=devnull,stdin=devnull)
        time.sleep(1)
        #stdout, stderr = imload.communicate()
        for j in EXPR :
            subprocess.run(['imv-msg',str(imload.pid),"open",os.path.expanduser(os.path.join(images_path,j.replace('#','').lower()+".png"))])
        subprocess.run(['imv-msg',str(imload.pid),"goto",str(random.randint(1,len(EXPR)))])
    print('',end='')
    with model.chat_session(system_prompt=system_prompt) :
        while user_input != "bye" :
            # print("\033[32;1;4m"+user_name+"\033[0m: ")
            user_input = input("\033[32;1;4m"+user_name+"\033[0m: ")
            print('',end='')
            while True:
                line = input("\033[3;4mContinue your input\033[0m: ")
                if not line: break  # Exit when user presses Enter without entering any text.
                user_input += "\n"+line
            if images_path :
                for  j in EXPR :
                    if j in user_input :
                        subprocess.run(['imv-msg',str(imload.pid),"goto",str(EXPR.index(j))])
            print(f'\033[33;1;4m{name}\033[0m: ',end='',flush=True)
            curr_response = ""
            curr_expr = ""
            for i in model.generate(prompt=user_input, temp=0,streaming=True,max_tokens=model_name[arg]["token_length"],repeat_last_n=500,repeat_penalty=1.1):
                    if images_path :
                        curr_response += str(i)
                        test = curr_response.split()
                        for j in EXPR :
                            if (j in test):
                                if j != curr_expr :
                                    curr_response =  curr_response.replace(j,'')
                                    test = curr_response.split()
                                    curr_expr = j
                                    subprocess.run(['imv-msg',str(imload.pid),"goto",str(EXPR.index(j))])
                                    break
                        print(i,end='',flush=True)
                    else :
                        print(i,end='',flush=True)
            print('')
    imload.kill()


def print_help():
    print('''
    \033[1;4mARGUMENTS\033[0m :
    "-c"                      \033[33m->\033[0m Create a custom character
    (name_of_saved_character) \033[33m->\033[0m loads the saved character
    ''')
    print("\033[1;4mList of saved characters\033[0m")
    for i in model_name:
        print("\033[34m->\033[0m "+i)

### The main program


if len(ARGUMENTS) > 1 :
    ARG = ARGUMENTS[1]
else :
    print_help()
    quit()
if ARG in model_name :
    main(ARG)
elif ARG in ["-c","--custom","-t","--temp"] :
    temp_arg = subprocess.check_output(["date","+%s"]).decode("utf-8")
    print("Enter the name of your character :",end="",flush=True)
    temp_name = input()
    print("Select_model:")
    models = subprocess.check_output("ls /home/devanandpa/sourced/llms/Models/ | grep gguf$",shell=True)
    temp_model = subprocess.check_output(["fzf","--prompt=Select model to load"],input=models).decode("utf-8").rstrip()
    print("Enter the scenario that you are in :",end="",flush=True)
    temp_scenario = input()
    try :
        temp_token_length = int(input("Enter a token length (or use default)"))
    except :
        temp_token_length = 500

    model_name[temp_arg] = {
        "model"  : "/home/devanandpa/sourced/llms/Models/"+temp_model,
        "name" : temp_name,



        "system_prompt" : temp_scenario,
        "token_length" : temp_token_length
    }
    main(temp_arg)
else :
    print("Model not found")

