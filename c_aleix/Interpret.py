# -*- encoding: utf-8 -*-
import serial

"""
================
Interpret Module
================

.. module:: Interpret
   :platform: GNU/Linux
   :synopsis: Interpret module contains class Interpret and its methods

.. moduleauthor:: Roger Solans i Aleix Gil

Aquest mòdul incorpora la classe Interpret, que simula una interfície de control
com podria ser la shell d'UNIX per tal d'oferir un seguit de comandes que permeten
controlar el semàfor.

Class and methods definition
============================
"""


class OrderError(Exception):
    pass

class HelpOrderError(Exception):
    pass

class ParameterError(Exception):
    pass

class Interpret(object):
    """
    Un intèrpret amb un receptari associat, un prompt i un diccionari d'ordres com
    a atributs
    """
    def __init__(self):
        """
        Construeix un objecte intèrpret a partir del receptari introduït com a
        argument
        """
        self.__prompt = '** '
        self.__dcom = {}
        self.__alpha = funcioneutra
        self.__omega = funcioneutra

    def set_begin(self, f):
        """
        Fixa la funció f com l’inicialitzador que es cridarà just abans d’arrencar
        l’interpret. f és una funció sense paràmetres.
        """
        self.__alpha = f

    def set_end(self, f):
        """
        Fixa la funció f com el finalitzador que es cridarà just abans d'acabar
        l'execució de l’interpret. f és una funció sense paràmetres.
        """
        self.__omega = f

    def set_prompt(self, p):
        """
        Modifica el prompt de l'intèrpret i el canvia per p
        """
        self.__prompt = p

    def afegeix_ordre(self, nomc, ordre, missatge):
        """
        Afegeix al diccionari una entrada amb el nom de l'ordre com a clau i la
        funció associada com a valor
        """
        try:
            if nomc in self.__dcom:
                raise Exception
            self.__dcom[nomc] = [ordre, missatge]
        except:
            print 'ERROR: Ja existeix una ordre amb aquest nom'

    def run(self):
        """
        Inicialitza l'intèrpret i el prepara per processar les ordres d'entrada
        """
        acaba = False
        self.__alpha()
        while not acaba:
            try:
                ordre = raw_input(self.__prompt)
                mots = ordre.split()
                nomordre = mots[0]
                if nomordre == 'surt':
                    acaba = True
                elif nomordre == 'ajuda':
                    if len(mots) > 1:
                        parametres = mots[1:]
                        if ' '.join(parametres) in self.__dcom:
                            print '-----------------'
                            print self.__dcom[' '.join(parametres)][1]
                            print '-----------------'
                        elif ' '.join(parametres) == 'surt':
                            print '-----------------'
                            print 'Ordre |surt| : fi del programa'
                            print '-----------------'
                        elif ' '.join(parametres) == 'ajuda':
                            print '-----------------'
                            print "Ordre |ajuda [ordre]| : imprimeix per pantalla ajuda\nsobre l'ordre indicada"
                            print '-----------------'
                        else:
                            raise HelpOrderError
                    else:
                        print '-----------------'
                        print 'Ordres conegudes:'
                        print '-----------------'
                        for i in sorted(self.__dcom.keys() + ['ajuda', 'surt']):
                            print i
                        print '-----------------'
                elif nomordre in self.__dcom:
                    if len(mots) > 1:
                        parametres = mots[1:]
                        funcio = self.__dcom[nomordre][0]
                        funcio(parametres)
                    else:
                        funcio = self.__dcom[nomordre][0]
                        funcio()
                else:
                    raise OrderError
            except IndexError:
                pass
            except ValueError:
                print 'ERROR: El nombre de paràmetres introduïts és invàlid'
            except ParameterError:
                print 'ERROR: El nombre de paràmetres introduïts és invàlid'
            except OrderError:
                print 'ERROR: No existeix cap ordre de nom ' + nomordre
            except HelpOrderError:
                print 'ERROR: No existeix cap ordre de nom ' + ' '.join(parametres)
            except IOError:
                print 'ERROR: No existeix cap arxiu de nom ' + nomarxiu
        self.__omega()

def funcioneutra():
    """
    No duu a terme cap acció
    """
    pass
