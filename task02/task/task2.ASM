format PE console
entry start
include 'win32a.inc'
;
; Штанько Екатерина БПИ193
; Вариант 27 (то есть 7) - B состоит из индексов положительных элементов A
;
;     Разработать программу, которая вводит одномерный массив A[N], формирует из элементов массива A новый массив B,
;состоящий из индексов положительных элементов A, и выводит его. Память под массивы может выделяться как статически, так и динамически по выбору разработчика.
;Разбить решение задачи на функции следующим образом:
;        1       Ввод и вывод массивов оформить как подпрограммы.
;        2       Формирование массива B оформить как процедуру
;        3       Организовать вывод как исходного, так и сформированного массивов
;Указанные процедуры могут использовать данные напрямую (имитация процедур без параметров). Имитация работы с параметрами также допустима.
;
;--------------------------------------------------------------------------
section '.data' data readable writable

    strSize   db  'Input N : ', 0
    strError  db  'Input error!', 10, 0
    strElem   db  '[%d] : ', 0
    strOut    db  '[%d] = %d', 10, 0
    strFmt    db  '%d', 0
    msg       db  'Result', 10, 0
    
    N         dd  0
    A         rd  256
    B         rd  256
    Len       db  0
;--------------------------------------------------------------------------
section '.code' code readable executable
start:
    ; ввод массива A
    push N
    push A
    call InputArray
  
    push Len
    push B
    push [N]
    push A
    call Calculate
;    
    cinvoke printf, msg
    push Len
    push B
    call OutputArray    
.finish:
    invoke getch
    invoke ExitProcess, 0

;--------------------------------------------------------------------------

;  Ввод массива
proc InputArray
    ; ESI : адрес массива
    mov esi, [esp + 4]
    ; EBX : счетчик итераций
    mov ebx, 0
    ; адрес N
    mov edi, [esp+8]
    ; ввод N
    cinvoke printf, strSize
    cinvoke scanf, strFmt, edi
    cmp byte [edi], 0
    jle  PrintError
    test eax, 1
    jz  PrintError    
.input:
    cinvoke printf, strElem, ebx 
    cinvoke scanf, strFmt, esi
    test eax, 1
    jnz .next
    call PrintError
.next:    
    add esi, 4
    inc ebx
    cmp ebx, [edi]
jne .input
  ret
endp

;--------------------------------------------------------------------------

;Вывод массива
proc OutputArray
    ; ESI : адрес массива
    mov esi, [esp + 4]
    ; адрес len
    mov edi, [esp+8] 
    cmp byte [edi], 0
    je  .exit   
    ; EBX : счетчик итераций
    mov ebx, 0
.output:
    cinvoke printf, strOut, ebx , [esi]
    add esi, 4
    inc ebx
    cmp ebx, [edi] 
jne .output
.exit:
  ret
endp

;--------------------------------------------------------------------------

;Выполнение задачи
proc Calculate
    ; ESI : адрес массива A
    mov esi, [esp + 4]
    ; адрес N
    mov ecx, [esp + 8]
    ; EDI : адрес массива B
    mov edi, [esp + 12]
    ; адрес Len
    mov ebx, [esp + 16]
    ; под индексы
    xor edx, edx
.calc:    
    lodsd   ; eax = элемент A из DS:ESI
            ; ESI += 4
    cmp eax, 0
    jle .next
    mov eax, edx
    stosd   ; записать индекс в B   
    inc byte [ebx]    
.next:
    inc edx
loop .calc
  ret
endp

;--------------------------------------------------------------------------

;В случае неверных данных
PrintError:
    cinvoke printf, strError
    invoke getch
    invoke ExitProcess, 0
    
;--------------------------------------------------------------------------

section '.idata' import data readable
library kernel, 'kernel32.dll',msvcrt, 'msvcrt.dll',user32,'user32.dll'

include 'api\user32.inc'
include 'api\kernel32.inc'
import kernel, ExitProcess, 'ExitProcess'

include 'api\kernel32.inc'
import msvcrt,printf, 'printf',scanf, 'scanf',getch, '_getch'