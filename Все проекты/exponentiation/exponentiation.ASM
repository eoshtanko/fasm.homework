format PE console


entry start

include 'win32a.inc'

section '.data' data readable writable



        messageA db 'Enter A: ', 0

        messageO db 'Enter "*" to start : ',0



        formatChar db '%s', 0

        formatNumber db '%d', 0

        formatEnd db 'A %s A = %d', 0



        A dd ?

        O db ?


        NULL = 0



section '.code' code readable executable



        start:

                push messageA

                call [printf]



                push A

                push formatNumber

                call [scanf]



                push messageO

                call [printf]




                push O

                push formatChar

                call [scanf]



                mov esi, O

                mov al, [esi]



                mov ah, '*'

                cmp ah, al

                JE multiplication


                jmp Exit



                mov eax, 0

                mov ecx, 0



                multiplication:

                        mov ecx, [A]

                        imul ecx, [A]

                        jmp SuccessMessage


                SuccessMessage:

                         push ecx

                         push O

                         push formatEnd

                         call [printf]



                Exit:

                         call [getch]

                         push NULL

                         call [ExitProcess]



section '.idata' import data readable

    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll'

    import kernel,\
           ExitProcess, 'ExitProcess'

    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'

