    INCLUDE Irvine32.inc
    INCLUDELIB Irvine32.lib
    INCLUDELIB kernel32.lib
    INCLUDELIB user32.lib

    .data
            msg_ent byte "Enter Message (2000 characters max): ", 0
            plain_encod_msg byte 2000 DUP(0)                 ;message to be decoded holder
            plain_encod_length dword ?                       ;message length holder

            string1 byte 0Ah,"Please enter a number ranging from 1-8: ", 0;
            string2 byte "1. Encode a Message to file" , 0;
            string3 byte "2. Decode a Message from file" , 0;
            string5 byte "3. Show key from file" , 0;
            string6 byte "4. Decode a Message from console" , 0;
            string7 byte "5. Show encoded message on console" , 0;
            string8 byte "6. Exit" , 0;
            string9 byte "Wrong Input" , 0;




            key_ent byte "Enter Key (100 characters max): ", 0
            key byte 100 DUP(0)                 ;key holder
            key_length dword ?                   ; key length holder
            key_count dword 1

            result byte "Message: ", 0

            val DWORD 0

            ;File Handling
            write BYTE "Test something: " , 0
            
            encoded	BYTE "Encoded.txt",0
	        fileHandle HANDLE ?

            key_file	BYTE "key.txt",0
	        keyHandle HANDLE ?

            
    .code
    main PROC
           
            call crlf
            call clrscr
            call main_screen
           
    exit
    main ENDP
    
    main_screen PROC
        start:
        mov edx, OFFSET string1
        call WriteString
        call Crlf
        
        mov edx, OFFSET string2
        call WriteString
        call Crlf
        
        mov edx, OFFSET string3
        call WriteString
        call Crlf
        
        
        mov edx, OFFSET string5
        call WriteString
        call Crlf

  
        mov edx, OFFSET string6
        call WriteString
        call Crlf

        mov edx, OFFSET string7
        call WriteString
        call Crlf

        mov edx, OFFSET string8
        call WriteString
        call Crlf

        
        call ReadInt
        
        cmp eax , 6
        ja wrng
        cmp eax , 1
        jb wrng 
        cmp eax , 1
        je enc
        cmp eax , 2
        je dnc 
        cmp eax , 3
        je kyF
        cmp eax , 4
        je dcC
        cmp eax , 5
        je wrt
        cmp eax , 6
        je ext
        
        wrng:
        mov  edx,OFFSET string9
        mov  ebx,0                       
        call MsgBox
        jmp start

        enc:
        call InputData
        call uppercase
        call encode_it
        call WriteaFile
        call WriteaKey
        jmp start

        dnc:
        call reset
        call ReadaFile
        call ReadaKey
        call uppercase
        call decode_it
        mov esi , OFFSET plain_encod_msg
        mov ecx , SIZEOF plain_encod_msg
        call writeastring
        jmp start

        kyF:
        call ReadaKey
        mov esi , OFFSET key
        mov ecx , SIZEOF key
        call writeastring
        jmp start

      


        dncO:
        call ReadaFile
        mov esi , OFFSET plain_encod_msg
        mov ecx , SIZEOF plain_encod_msg
        call writeastring
        jmp start

        dcC:
        call reset
        call InputData
        call uppercase
        call decode_it
        mov esi , OFFSET plain_encod_msg
        mov ecx , SIZEOF plain_encod_msg
        call writeastring
        jmp start

        wrt:
        call reset
        call ReadaFile
        mov esi , OFFSET plain_encod_msg
        mov ecx , SIZEOF plain_encod_msg
        call writeastring
        call crlf
        call ReadaKey
        mov esi , OFFSET key
        mov ecx , SIZEOF key
        call writeastring
        jmp start

        
        ext:

    ret
    main_screen ENDP

    reset PROC 
            mov plain_encod_length , 0
            mov key_length, 0
            mov key_count, 1
            mov plain_encod_msg , 0
            mov key , 0
    ret
    reset ENDP

    writeastring PROC

    looping:
    mov al, BYTE PTR [esi]
    cmp al , 36
    je ext
    call WriteChar
    inc esi
    loop looping
    ext:
    ret
    writeastring ENDP

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
        inc esi
       
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
        
        mov esi ,offset plain_encod_msg
        add esi, eax 
        mov eax , '$'
        mov [esi], eax 
       
        ;printing message to user to enter the key to decode the message
        mov edx, offset key_ent
        call writestring

        ;taking key form user to decode the message
        mov edx, offset Key
        mov ecx, sizeof key 
        call Readstring 
        mov key_length, eax

        mov esi ,offset Key
        add esi, eax
        mov eax , '$'
        mov [esi], eax 
  


    ret
    InputData ENDP

    ReadaFile PROC
        mov edx,OFFSET encoded
	    call OpenInputFile
	    mov fileHandle,eax

	    mov  eax,fileHandle
        mov  edx,OFFSET plain_encod_msg
        mov  ecx, SIZEOF plain_encod_msg
        call ReadFromFile
        mov  esi,OFFSET plain_encod_msg
        mov  ecx, SIZEOF plain_encod_msg
        countloop:
        mov al, BYTE PTR [esi]
        cmp al, 36
        JE brk
        inc esi
        inc plain_encod_length
        loop countloop
        brk:

        mov  eax,fileHandle
        call CloseFile

     
    ret 
    ReadaFile ENDP
    ReadaKey PROC
        mov edx,OFFSET key_file
	    call OpenInputFile
	    mov keyHandle,eax

	    mov  eax,keyHandle
        mov  edx,OFFSET key
        mov  ecx, SIZEOF key
        call ReadFromFile

        mov  esi,OFFSET key
        mov  ecx, SIZEOF key
        countloop2:
        mov al, BYTE PTR [esi]
        cmp al, 36
        JE brk2
        inc esi
        inc key_length
        loop countloop2
        brk2:
        
        mov  eax,keyHandle
        call CloseFile
        
    ret
    ReadaKey ENDP


    Writeafile PROC
            mov  edx,OFFSET encoded
            call CreateOutputFile
            mov  filehandle, EAX

            mov  eax,fileHandle
            mov  edx,OFFSET plain_encod_msg
            mov  ecx, SIZEOF plain_encod_msg
            call WriteToFile
	        call Crlf

            mov  eax,fileHandle
            call CloseFile
            
    ret
    WriteaFile ENDP 
    WriteaKey PROC
            mov  edx,OFFSET key_file
            call CreateOutputFile
            mov  keyHandle, EAX

            mov  eax,keyHandle
            mov  edx,OFFSET key
            mov  ecx, SIZEOF key
            call WriteToFile
	        call Crlf

            mov  eax,keyHandle
            call CloseFile
    ret
    Writeakey ENDP 



    uppercase PROC ; (done)

        mov esi, offset plain_encod_msg
        mov ecx, plain_encod_length

        upCase:
            mov al, [esi]
            cmp al , 36
            je out1
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
        out1:

        mov esi, offset key
        mov ecx, key_length

        keyupCase:
            mov al, [esi]
            cmp al , 36
            je out2
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
        out2:
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

            cmp eax, 36
            je ext

            
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
        ext:
    ret
    decode_it ENDP

    END main
