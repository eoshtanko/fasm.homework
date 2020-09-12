format PE console


entry start

include 'win32a.inc'

section '.data' data readable writable



        messageA db 'Enter A: ', 0

        messageB db 'Enter B: ', 0


        messageI db 'Operations: +, -, *, /', 10, 13, 0

        messageO db 'Enter operation : ',0



        formatChar db '%s', 0

        formatNumber db '%d', 0

        formatEnd db 'A %s B = %d', 0



        A dd ?

        B dd ?

        C dd ?

        O db ?


        NULL = 0



section '.code' code readable executable



        start:

                push messageA

                call [printf]



                push A

                push formatNumber

                call [scanf]



                push messageB

                call [printf]




                push B

                push formatNumber

                call [scanf]



                push messageI

                call [printf]



                push messageO

                call [printf]




                push O

                push formatChar

                call [scanf]



                mov esi, O

                mov al, [esi]



                mov ah, '+'

                cmp ah, al

                JE plus


                mov ah, '-'

                cmp ah, al

                JE subtraction


                mov ah, '*'

                cmp ah, al

                JE multiplication



                mov ah, '/'

                cmp ah, al

                JE division



                jmp Exit



                mov eax, 0

                mov ecx, 0







                plus:

                        mov ecx, [A]

                        add ecx, [B]

                        jmp SuccessMessage

                subtraction:

                        mov ecx, [A]

                        sub ecx, [B]

                        jmp SuccessMessage

                multiplication:

                        mov ecx, [A]

                        imul ecx, [B]

                        jmp SuccessMessage

                division:

                        mov eax, [A]

                        mov ecx, [B]

                        mov edx, 0



                        div ecx

                        mov ecx, eax



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
