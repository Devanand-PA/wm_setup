#!/bin/python
import sys
import subprocess
import os

pass_path = os.path.expanduser("~/.scripts/pass.py/pass")
gpg_pass = ""
passwd = ""
sel_pass = ""
mode = subprocess.check_output(
        ["dmenu","-l","30","-p","What do you want to do"],
        input="Enter a password\nAccess a password",
        text=True
        ).rstrip()

if mode == "Enter a password" :
    passname = subprocess.check_output(
        ["dmenu","-l","30","-p","Enter the name of the password"],
        text=True,
        input=""
        ).rstrip()

    if passname :
        passwd = subprocess.check_output(
        ["dmenu","-l","30","-p","Enter the password you want to save"],
        text=True,
        input=""
        ).rstrip()
    else :
        sys.exit("Enter a name for your password")

    if passwd :
        gpg_pass = subprocess.check_output(
        ["dmenu","-l","30","-p","Enter the gpg encryption password"],
        text=True,
        input=""
        ).rstrip()
    else :
        sys.exit("No password entered")

    if gpg_pass :
        subprocess.run(
                ['gpg','--batch','--output',os.path.join(pass_path,f"{passname}.gpg"),"--passphrase",gpg_pass,'--symmetric'],
                input=passwd,
                text=True
                )
        subprocess.run('gpg-connect-agent',text=True,input="RELOADAGENT")
    else :
        sys.exit("No password entered")


#========================================================
# Access pass wprd 
elif mode == "Access a password" :
    passes = os.listdir(pass_path)
    dmenu_input = "\n".join(passes)
    passname = subprocess.check_output(
            ["dmenu","-l","30","-p","Choose password"],
            text=True,
            input=dmenu_input
            ).rstrip()
    gpg_pass = subprocess.check_output(
        ["dmenu","-l","30","-p","Enter the gpg encryption password"],
        text=True,
        input=''
        ).rstrip()
    
    if gpg_pass  :
        final_pass = subprocess.check_output(
                ['gpg','--decrypt',os.path.join(pass_path,passname)],
                text=True
                )
        subprocess.run('gpg-connect-agent',text=True,input="RELOADAGENT")
        subprocess.run(["xclip","-sel","clip"],text=True,input=final_pass)

    




    
else :
    sys.exit("No mode chosen")
