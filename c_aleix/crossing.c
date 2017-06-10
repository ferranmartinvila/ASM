#include "control.h"
#include "serial_device.h"
#include "blck_serial.h"
#include "ether.h"

void print_state(street_t street)
{
    semaph_state_t state = control_get_state(street);
    switch (state) {
        case SemClear:
        {
            print("CLEAR\r\n");
            return;
        }
        case SemApproach:
        {
            print("APPROACH\r\n");
            return;
        }
        case SemStop:
        {
            print("STOP\r\n");
            return;
        }
        case SemOff:
        {
            print("OFF\r\n");
            return;
        }
    }
}

void main()
{
    serial_open();
    control_init();
    ether_init();

    char s[2];
    street_t street;
    int error;

    while(1) {
        if (serial_can_read()) {
            s[0] = ' ';
            s[1] = ' ';
            error = 0;

            readline(s, 2);
            if (s[1] != ' ') {
                switch (s[1]) {
                    case 'A':
                    {
                        street = StreetA;
                        break;
                    }
                    case 'B':
                    {
                        street = StreetB;
                        break;
                    }
                    default:
                    {
                        print("COMERROR\r\n");
                        error = 1;
                    }
                }
            }

            if (!error) {
                switch (s[0]) {
                    case 'F':
                    {
                        // Força els semàfors
                        control_force(street);

                        // Replica la ordre
                        switch (street) {
                            case StreetA:
                                ether_put('F');
                                ether_put('A');
                                ether_put(' ');
                                break;
                            case StreetB:
                                ether_put('F');
                                ether_put('B');
                                ether_put(' ');
                                break;
                        }

                        // Confirma per terminal
                        print("OK\r\n");
                        break;
                    }
                    case 'W':
                    {
                        print_state(street);
                        break;
                    }
                    case 'H':
                    {
                        // Apaga els semàfors
                        control_off();

                        // Replica la ordre
                        ether_put('H');
                        ether_put(' ');

                        // Confirma per terminal
                        print("OK\r\n");
                        break;
                    }
                    case 'R':
                    {
                        // Engega els semàfors
                        control_on();

                        // Replica la ordre
                        ether_put('R');
                        ether_put(' ');

                        // Confirma per terminal
                        print("OK\r\n");
                        break;
                    }
                    default:
                    {
                        print("COMERROR\r\n");
                    }
                }
            }
        }
    }
}
