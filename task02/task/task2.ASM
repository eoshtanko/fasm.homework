format PE console
entry start
include 'win32a.inc'
;
; ������� ��������� ���193
; ������� 27 (�� ���� 7) - B ������� �� �������� ������������� ��������� A
;
;     ����������� ���������, ������� ������ ���������� ������ A[N], ��������� �� ��������� ������� A ����� ������ B,
;��������� �� �������� ������������� ��������� A, � ������� ���. ������ ��� ������� ����� ���������� ��� ����������, ��� � ����������� �� ������ ������������.
;������� ������� ������ �� ������� ��������� �������:
;        1       ���� � ����� �������� �������� ��� ������������.
;        2       ������������ ������� B �������� ��� ���������
;        3       ������������ ����� ��� ���������, ��� � ��������������� ��������
;��������� ��������� ����� ������������ ������ �������� (�������� �������� ��� ����������). �������� ������ � ����������� ����� ���������.
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
    ; ���� ������� A
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

;  ���� �������
proc InputArray
    ; ESI : ����� �������
    mov esi, [esp + 4]
    ; EBX : ������� ��������
    mov ebx, 0
    ; ����� N
    mov edi, [esp+8]
    ; ���� N
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

;����� �������
proc OutputArray
    ; ESI : ����� �������
    mov esi, [esp + 4]
    ; ����� len
    mov edi, [esp+8] 
    cmp byte [edi], 0
    je  .exit   
    ; EBX : ������� ��������
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

;���������� ������
proc Calculate
    ; ESI : ����� ������� A
    mov esi, [esp + 4]
    ; ����� N
    mov ecx, [esp + 8]
    ; EDI : ����� ������� B
    mov edi, [esp + 12]
    ; ����� Len
    mov ebx, [esp + 16]
    ; ��� �������
    xor edx, edx
.calc:    
    lodsd   ; eax = ������� A �� DS:ESI
            ; ESI += 4
    cmp eax, 0
    jle .next
    mov eax, edx
    stosd   ; �������� ������ � B   
    inc byte [ebx]    
.next:
    inc edx
loop .calc
  ret
endp

;--------------------------------------------------------------------------

;� ������ �������� ������
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