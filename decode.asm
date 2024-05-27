INCLUDE    Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib
.data
    cword BYTE "Z", 0
    key   BYTE "H"

.code
main PROC

    mov edx, 0
    mov esi, offset cword ;E
    mov edi, offset key   ;K

    movzx ebx, byte ptr [edi] ; moving the  byte 8 bit to 32 bit register
    sub   ebx, 65             ; ASCII code For alphabets starts form the 65
    movzx eax, byte ptr [esi]
    sub   eax, 65

    sub eax, ebx
    mov ecx, 26
    div ecx
    mov eax, edx
    add eax , 65
    call writeChar

    
exit
main ENDP
END  main