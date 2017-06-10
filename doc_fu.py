import time
import os
import random

# Commentary
#h = 0

#while h <= 10:
#    os.system('cls') # Clear screen
#    print h
#    h+=1
#    time.sleep(1) # Delay of one second


var = "string gone wild"
var_s = ""
for k in var:

    os.system('cls') # Clear screen
    var_s += k
    print var_s
    time.sleep(0.2) # Delay of one second


"""

var = "abcdefghijklmnopqrts      21342142412421"

while 1:

    k = 0
    temporal_var = ""
    var_rand = random.randint(1,100)

    while k < var_rand:

        temporal_var += random.choice(var)
        k += 1

    print temporal_var

"""

"""

print "Quan es 2 + 2"
var = raw_input("La resposta es: ")

if var == "quatre":
     print "Ets un mastodonte"

else:
    print "Noob"

"""
