# -*- encoding: utf-8 -*-
import serial
import Interpret

def inicial():
    # Funció inicial. Obre el port i escriu el missatge de benvinguda
 
    print "Benvingut al supervisor del control semafòric"
    global ser
    try:
        ser = serial.Serial('/dev/ttyACM0')
    except:
        print "ERROR Prova d'executar en mode sudo, o comprova si l'Arduino està connectat"
        quit()
    #l = ''.join(e for e in ser.readline() if e.isalnum())

def final():
    """
    Funció final. Tanca el port i escriu el missatge de despedida
    """

    print "Apagant el supervisor"
    ser.close()

def start():
    """
    Envia la comanda d'inici "R" i espera per resposta "OK". Dóna error sinó
    """

    ser.write(b'R ')

    print ser.readline()


def stop():
    """
    Envia la comanda d'apagat "H" i espera per resposta "OK". Dóna error sinó
    """

    ser.write(b'H ')

    print ser.readline()


def emergencyA():
    """
    Envia la comanda d'emergència "FA" i espera per resposta "OK". Dóna error sinó
    """

    ser.write(b'FA')

    print ser.readline()

def emergencyB():
    """
    Envia la comanda d'emergència "FB" i espera per resposta "OK". Dóna error sinó
    """

    ser.write(b'FB')

    print ser.readline()


def whichA():
    """
    Envia la comanda "WA" i retorna la resposta
    """

    ser.write(b'WA')

    print ser.readline()

def whichB():
    """
    Envia la comanda "WB" i retorna la resposta
    """

    ser.write(b'WB')

    print ser.readline()

i = Interpret.Interpret()
i.set_begin(inicial)
i.set_end(final)
i.afegeix_ordre('start', start, 'Engega el cicle ordinari del semàfor')
i.afegeix_ordre('stop', stop, 'Atura el cicle del semàfor')
i.afegeix_ordre('forceA', emergencyA, 'Força el semàfor A a recomençar el cicle')
i.afegeix_ordre('forceB', emergencyB, 'Força el semàfor B a recomençar el cicle')
i.afegeix_ordre('whichA', whichA, 'Mostra l\'estat del semàfor A')
i.afegeix_ordre('whichB', whichB, 'Mostra l\'estat del semàfor B')
i.run()
