    INCLUDE    Irvine32.inc
    INCLUDELIB Irvine32.lib
    INCLUDELIB kernel32.lib
    INCLUDELIB user32.lib

    ;this logic is for encoding
    .data
    ; this was the initial logic test that wheather that mod formula will be possible or not
    bu   dword "S", 0
    key  dword "H", 0
    .code
    main PROC

    mov edx, 0          ;where remanider will live
    mov esi, offset bu  ;the address to be decoded
    mov edi, offset key ; the key address 

   movzx ebx, byte ptr [edi] ; moving the  byte 8 bit to 32 bit register
    sub   ebx, 65             ; ASCII code For alphabets starts form the 65
    movzx eax, byte ptr [esi]
    sub   eax, 65

    add eax, ebx ; adding both  numbers
    mov ecx, 26  ; moving divider
    div ecx      ;division
    mov eax, edx ; moving the remainder to eax
    add eax, 65  ; addinng 65 thats where ASCII code begin

    mov  [esi], eax
    mov  edx,   offset bu
    call writestring
    call crlf
    exit
    main ENDP


    END main
