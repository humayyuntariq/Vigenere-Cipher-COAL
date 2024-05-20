    INCLUDE Irvine32.inc
    INCLUDELIB Irvine32.lib
    INCLUDELIB kernel32.lib
    INCLUDELIB user32.lib

    .data
        msg byte "hello", 0
    .code
    main PROC
       mov esi, offset msg
       add esi, 4
       mov eax, [esi]
       call writechar
       call crlf

    exit
    main ENDP


    END main
