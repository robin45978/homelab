def ping():
    import os
    ip = ["192.168.178.1","1.1.1.1"]
    i=0
    ips = len(ip)


    while i < ips:f

        response = os.system("ping -n 1 " + ip[i] + " >nul")

        if response == 0:
            print(ip[i],"Erreichbar")
        else:
            print(ip[i],"Nicht erreichbar!")
        i = i + 1

ping()
