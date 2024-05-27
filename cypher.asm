    INCLUDE Irvine32.inc
    INCLUDELIB Irvine32.lib
    INCLUDELIB kernel32.lib
    INCLUDELIB user32.lib

    .data
            msg_ent byte "Enter Message (2000 characters max): ", 0
            plain_encod_msg byte 2000 DUP(0)                 ;message to be decoded holder
            plain_encod_length dword ?                       ;message length holder

            key_ent byte "Enter Key (100 characters max): ", 0
            key byte 100 DUP(0)                 ;key holder
            key_length dword ?                   ; key length holder
            key_count dword 1

            result byte "Message: ", 0

            val DWORD 0
            
    .code
    main PROC
             ;clearing the screen
                call crlf
                call clrscr

            ; call InputData
            ; call uppercase
            ; call encode_it


            ; ;printing the result
            ; mov edx, offset result
            ; call writestring
            ; mov edx, offset plain_encod_msg
            ; call writestring
            ; call crlf

            call InputData
            call uppercase
            call decode_it

              ;printing the result
            mov edx, offset result
            call writestring
            mov edx, offset plain_encod_msg
            call writestring
            call crlf


    exit
    main ENDP


    encode_it PROC

        ;moving the address of palin text and key to registers
        mov esi, offset plain_encod_msg 
        mov edi, offset key 
        
        ;setting the number of iteration of loop to number of character to plaintext
        mov ecx, plain_encod_length

        encodingg:
            push ecx ; saving ecx because we are gonna need ecx for taking mod
            ;moving the letter of message and key into register for furhter operation
            mov eax, 0
            mov ebx, 0
            movzx eax, byte ptr [esi]
            movzx ebx, byte ptr [edi]

            ;skippping the space in sentence
            cmp eax, 32
            je nextt
            
            ;in ASCII code they alphabet start at 65 so subtracting 65 & 65 for both alphabet to get them at zero indexxing
            sub eax, 65
            sub ebx, 65

            ; encryption = (eax + ebx ) mod 26
            add eax, ebx  

            cmp eax, 26
            jb changee
            
            mov edx, 0
            mov ecx, 26
            div ecx
            mov eax, edx

            changee:
            add eax, 65
            mov [esi], al

            ;key increment
            inc edi
            inc key_count

            ;checking if the key is greater than the total character of key, if so then reset edi, counter to begiinging
            mov eax, key_count
            mov ebx, key_length
            cmp eax, ebx
            ja backtostart
            jmp ending_encod

            backtostart: 

            mov edi, offset key
            ;call DumpRegs
            mov key_count, 1

            ending_encod:
            
            nextt:
            inc esi
            pop ecx
        loop encodingg

    ret
    encode_it ENDP

    InputData PROC ; (done)
       
        ;print the message on screen to enter the encoded message
        mov edx, offset msg_ent
        call WriteString

        ;taking decoded message form the user and 
        mov edx, offset plain_encod_msg
        mov ecx, sizeof plain_encod_msg
        call ReadString 
        mov plain_encod_length, eax 


        ;printing message to user to enter the key to decode the message
        mov edx, offset key_ent
        call writestring

        ;taking key form user to decode the message
        mov edx, offset Key
        mov ecx, sizeof key 
        call Readstring 
        mov key_length, eax


    ret
    InputData ENDP

    uppercase PROC ; (done)

        mov esi, offset plain_encod_msg
        mov ecx, plain_encod_length

        upCase:
            mov al, [esi]
            cmp al, ' '
            je case_ending
            cmp al, 'a'
            jae secondctd
            jmp case_ending 

            secondctd:
            cmp al, 'z'
            jbe toupppercase
            jmp case_ending

            toupppercase:
            sub al, 32
            mov [esi], al

            case_ending:
            inc esi
        loop upCase

        mov esi, offset key
        mov ecx, key_length

        keyupCase:
            mov al, [esi]
            cmp al, 'a'
            jae sectd
            jmp keycase_ending 

            sectd:
            cmp al, 'z'
            jbe keytoupppercase
            jmp case_ending

            keytoupppercase:
            sub al, 32
            mov [esi], al

            keycase_ending:
            inc esi
        loop keyupCase
    ret
    uppercase ENDP

    decode_it PROC
      ;moving the address of palin text and key to registers
        mov esi, offset plain_encod_msg 
        mov edi, offset key 
        
        ;setting the number of iteration of loop to number of character to plaintext
        mov ecx, plain_encod_length

        decoding:
            push ecx ; saving ecx because we are gonna need ecx for taking mod
            ;moving the letter of message and key into register for furhter operation
            mov eax, 0
            mov ebx, 0
            movzx eax, byte ptr [esi]
            movzx ebx, byte ptr [edi]

            ;skippping the space in sentence
            cmp eax, 32
            je nextt_dec
            
            ;in ASCII code they alphabet start at 65 so subtracting 65 & 65 for both alphabet to get them at zero indexxing
            sub eax, 65
            sub ebx, 65

            ; decryption = (eax - ebx ) mod 26
            sub eax, ebx  
            cmp eax , 0
            jl changesign
            jnl no_changesign
            changesign:
                add eax, 26
                jmp no_changesign
            no_changesign:
            cmp eax, 26
            jl changee_dec

            call writeInt
            mov edx, 0
            mov ecx, 26
            div ecx
            mov eax, edx

            changee_dec:
            add eax, 65
            mov [esi], al

            ;key increment
            inc edi
            inc key_count

            ;checking if the key is greater than the total character of key, if so then reset edi, counter to begiinging
            mov eax, key_count
            mov ebx, key_length
            cmp eax, ebx
            ja backtostart_dec
            jmp ending_encod_dec

            backtostart_dec:
            mov edi, offset key
            mov key_count, 1
            ending_encod_dec:
            nextt_dec:
            inc esi
            pop ecx
        loop decoding
    ret
    decode_it ENDP

    END main
