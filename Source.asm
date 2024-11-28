include irvine32.inc

.data
    byteArr BYTE 9, 8, 7, 5, 6, 2, 3, 1, 4, 10
    wordArr WORD 99, 88, 77, 55, 66, 22, 33, 11, 44, 110
    dwordArr DWORD 999, 888, 777, 555, 666, 222, 333, 111, 444, 1110
    count DWORD 10

    chooseSortingType BYTE "Select 1, 2, 3, 4, 5 or 6 to choose between the following sorts: ", 0
    displaySorts BYTE "[ Bubble Sort, Selection Sort, Insertion Sort, Merge Sort, Quick Sort, Pancake Sort ]", 0
    enterSize BYTE "Select 1, 2 or 4 to perform BYTE, WORD or DWORD sorting: ", 0

    displayOldArr BYTE "Displaying array before sorting: ", 0
    displayNewArr BYTE "Displaying array after sorting: ", 0

.code
main proc
    lea edx, displaySorts
    call writestring
    call crlf

    lea edx, chooseSortingType
    call writestring
    call readint
    push eax ; parameter 2 -> store selection in stack
    call crlf

    lea edx, enterSize
    call writestring
    call readint
    push eax ; parameter 1 -> store size of array in stack
    call crlf

    call selectAndPerformSort
    call crlf

    exit
main endp

selectAndPerformSort proc
    push ebp
    mov ebp, esp

    mov eax, [ebp + 12] ; sorting type
    mov ebx, [ebp + 8]  ; size of array

    lea edx, displayOldArr
    call writestring
    call crlf
    
    cmp eax, 1
    je callBubbleSort
    cmp eax, 2
    je callSelectionSort
    cmp eax, 3
    je callInsertionSort
    cmp eax, 4
    je callMergeSort
    cmp eax, 5
    je callQuickSort
    cmp eax, 6
    je callPancakeSort

    jmp endSort

    callBubbleSort:
        call BubbleSort
        jmp endSort

    callSelectionSort:
        call SelectionSort
        jmp endSort

    callInsertionSort:
        call InsertionSort
        jmp endSort

    callMergeSort:
        jmp endSort

    callQuickSort:
        jmp endSort

    callPancakeSort:
        call PancakeSort
        jmp endSort

    endSort:
        pop ebp
    ret

selectAndPerformSort endp

BubbleSort proc USES ebx

    cmp ebx, 4
    je dwordd

    cmp ebx, 2
    je wordd

    cmp ebx, 1
    je bytee

    ret

    dwordd:
        call PrintArray
        call crlf
        lea edx, displayNewArr
        call writestring
        call crlf
        call BubbleSort_DWORD

        ret

    wordd:
        call PrintArray
        call crlf
        lea edx, displayNewArr
        call writestring
        call crlf
        call BubbleSort_WORD

        ret

    bytee:
        call PrintArray
        call crlf
        lea edx, displayNewArr
        call writestring
        call crlf
        call BubbleSort_BYTE
    
        ret

BubbleSort endp

BubbleSort_DWORD PROC

    mov ecx, LENGTHOF dwordArr
    dec ecx

    outerLoop:
        mov esi, 0
        mov edi, ecx

    innerLoop:
        mov eax, [dwordArr + esi * TYPE dwordArr]
        inc esi
        mov ebx, [dwordArr + esi * TYPE dwordArr]
        dec esi

        cmp eax, ebx
        jle noSwapping

        ; swap if greater
        mov [dwordArr + esi * TYPE dwordArr], ebx
        inc esi
        mov [dwordArr + esi * TYPE dwordArr], eax
        dec esi

    noSwapping:
        inc esi
        dec edi
        jnz innerLoop

        dec ecx
        jnz outerLoop
    
    ; resetting ebx
    mov ebx, 4
    call PrintArray

    ret

BubbleSort_DWORD endp

BubbleSort_WORD PROC

    mov ecx, LENGTHOF wordArr
    dec ecx

    outerLoop:
        mov esi, 0
        mov edi, ecx

    innerLoop:
        mov ax, [wordArr + esi * TYPE wordArr]
        inc esi
        mov bx, [wordArr + esi * TYPE wordArr]
        dec esi

        cmp ax, bx
        jle noSwapping

        ; swap if greater
        mov [wordArr + esi * TYPE wordArr], bx
        inc esi
        mov [wordArr + esi * TYPE wordArr], ax
        dec esi

    noSwapping:
        inc esi
        dec edi
        jnz innerLoop

        dec ecx
        jnz outerLoop
    
    ; resetting ebx
    mov ebx, 2
    call PrintArray

    ret

BubbleSort_WORD endp

BubbleSort_BYTE PROC

    mov ecx, LENGTHOF byteArr
    dec ecx

    outerLoop:
        mov esi, 0
        mov edi, ecx

    innerLoop:
        mov al, [byteArr + esi * TYPE byteArr]
        inc esi
        mov bl, [byteArr + esi * TYPE byteArr]
        dec esi

        cmp al, bl
        jle noSwapping

        ; swap if greater
        mov [byteArr + esi * TYPE byteArr], bl
        inc esi
        mov [byteArr + esi * TYPE byteArr], al
        dec esi

    noSwapping:
        inc esi
        dec edi
        jnz innerLoop

        dec ecx
        jnz outerLoop

    ; resetting ebx
    mov ebx, 1
    call PrintArray

    ret

BubbleSort_BYTE endp

SelectionSort proc USES ebx

    cmp ebx, 4
    je dwordd

    cmp ebx, 2
    je wordd

    cmp ebx, 1
    je bytee

    ret

    dwordd:
        call PrintArray
        call crlf
        lea edx, displayNewArr
        call writestring
        call crlf
        call SelectionSort_DWORD
    
        ret

    wordd:
        call PrintArray
        call crlf
        lea edx, displayNewArr
        call writestring
        call crlf
        call SelectionSort_WORD
        
        ret

    bytee:
        call PrintArray
        call crlf
        lea edx, displayNewArr
        call writestring
        call crlf
        call SelectionSort_BYTE
        
        ret

SelectionSort endp

SelectionSort_DWORD proc USES ebx
  
    push ebp
    mov  ebp, esp
    
    mov  ecx, count             ; num elements
    lea  ebx, dwordArr          ; pointing to first element in the array

    sub  ecx, 1
    jbe  endd                   ; no sorting if ecx = 0 || ecx = 1 

    outerLoop:
        mov edx, ecx            ; number of comparisons
        mov esi, ebx            ; unsorted part
        mov eax, [esi]          ; assume first element is minimum
        mov edi, esi            ; address of minimum value
     
        innerLoop:
            add esi, 4
            cmp [esi], eax
            jge notSmaller      ; skip !!
            mov eax, [esi]      ; update min value
            mov edi, esi        ; update min address

        notSmaller:
            dec edx
            jnz innerLoop

        ; swap min w/ first element in partition
        mov edx, [ebx]          ; temp = [ebx], original value
        mov [ebx], eax          ; place min value @ the beginning
        mov [edi], edx          ; min = temp

        add ebx, 4              ; move partition divider
        dec ecx
        jnz outerLoop
    
    endd:
        ; resetting ebx
        mov ebx, 4
        call PrintArray
        
        pop ebp
        ret

SelectionSort_DWORD endp

SelectionSort_WORD proc USES ebx

    push ebp
    mov  ebp, esp
    
    mov  ecx, count             ; num elements
    lea  ebx, wordArr           ; pointing to first element in the array

    sub  ecx, 1
    jbe  endd                   ; no sorting if ecx = 0 || ecx = 1 

    outerLoop:
        mov edx, ecx            ; number of comparisons
        mov esi, ebx            ; unsorted part
        mov ax, [esi]           ; assume first element is minimum
        mov edi, esi            ; address of minimum value
     
        innerLoop:
            add esi, 2
            cmp [esi], ax
            jge notSmaller      ; skip !!
            mov ax, [esi]       ; update min value
            mov edi, esi        ; update min address

        notSmaller:
            dec edx
            jnz innerLoop

        ; swap min w/ first element in partition
        mov dx, [ebx]           ; temp = [ebx], original value
        mov [ebx], ax           ; place min value @ the beginning
        mov [edi], dx           ; min = temp

        add ebx, 2              ; move partition divider
        dec ecx
        jnz outerLoop
    
    endd:
        ; resetting ebx
        mov ebx, 2
        call PrintArray
        
        pop ebp
        ret
   
SelectionSort_WORD endp

SelectionSort_BYTE proc USES ebx

    push ebp
    mov  ebp, esp
    
    mov  ecx, count             ; num elements
    lea  ebx, byteArr           ; pointing to first element in the array

    sub  ecx, 1
    jbe  endd                   ; no sorting if ecx = 0 || ecx = 1 

    outerLoop:
        mov edx, ecx            ; number of comparisons
        mov esi, ebx            ; unsorted part
        mov al, [esi]           ; assume first element is minimum
        mov edi, esi            ; address of minimum value
     
        innerLoop:
            add esi, 1
            cmp [esi], al
            jge notSmaller      ; skip !!
            mov al, [esi]       ; update min value
            mov edi, esi        ; update min address

        notSmaller:
            dec edx
            jnz innerLoop

        ; swap min w/ first element in partition
        mov dl, [ebx]           ; temp = [ebx], original value
        mov [ebx], al           ; place min value @ the beginning
        mov [edi], dl           ; min = temp

        add ebx, 1              ; move partition divider
        dec ecx
        jnz outerLoop
    
    endd:
        ; resetting ebx
        mov ebx, 1
        call PrintArray
        
        pop ebp
        ret
   
SelectionSort_BYTE endp

InsertionSort proc USES ebx

    cmp ebx, 4
    je dwordd

    cmp ebx, 2
    je wordd

    cmp ebx, 1
    je bytee

    ret

    dwordd:
        call PrintArray
        call crlf
        lea edx, displayNewArr
        call writestring
        call crlf
        call InsertionSort_DWORD
    
        ret

    wordd:
        call PrintArray
        call crlf
        lea edx, displayNewArr
        call writestring
        call crlf
        call InsertionSort_WORD
        
        ret

    bytee:
        call PrintArray
        call crlf
        lea edx, displayNewArr
        call writestring
        call crlf
        call InsertionSort_BYTE
        
        ret

InsertionSort endp

InsertionSort_DWORD proc USES ebx

	mov ecx, count
	dec ecx

	L1:                                           
		push ecx                      ; store the loop counter
		mov eax, ecx
		mov esi, OFFSET dwordArr
		mov ecx, count
		sub ecx, eax                  ; calculate number of loops
		mov eax, ecx
		mov edx, 4
		mul edx
		add esi, eax                  ; calculate address of tested number
		mov eax, [esi]                ; store the number to compare		
		mov esi, OFFSET dwordArr           ; restore esi to the beginning 

	L2:                               
		cmp eax, [esi]                ; if that number is less
		jl L3                         ; jump to next part
		add esi, 4                    
		loop L2                       ; if not
		jmp L5                        ; jump to the end of this loop

	L3:
		push esi                      ; store current position
		push eax
		mov eax, ecx
		mov edx, 4
		mul edx
		add esi, eax                  ; move to position of tested number
		pop eax

	L4:
		mov edx, [esi - 4]            ; copy the values to next position
		mov [esi], edx
		sub esi, 4                    
		loop L4
		pop esi                       ; restore current position
		mov [esi], eax                ; copy the tested number to [esi]

	L5:
		pop ecx                       ; restore the loop counter 
		loop L1

    endSorting:
        mov ebx, 4
        call PrintArray
    ret

InsertionSort_DWORD endp

InsertionSort_WORD proc USES ebx

	mov ecx, count
	dec ecx

	L1:                                           
		push ecx                      ; store the loop counter
		mov eax, ecx
		mov esi, OFFSET wordArr
		mov ecx, count
		sub ecx, eax                  ; calculate number of loops
		mov eax, ecx
		mov edx, 2
		mul edx
		add esi, eax                  ; calculate address of tested number
		mov ax, [esi]                ; store the number to compare		
		mov esi, OFFSET wordArr           ; restore esi to the beginning 

	L2:                               
		cmp ax, [esi]                ; if that number is less
		jl L3                         ; jump to next part
		add esi, 2                    
		loop L2                       ; if not
		jmp L5                        ; jump to the end of this loop

	L3:
		push esi                      ; store current position
		push eax
		mov eax, ecx
		mov edx, 2
		mul edx
		add esi, eax                  ; move to position of tested number
		pop eax

	L4:
		mov dx, [esi - 2]            ; copy the values to next position
		mov [esi], dx
		sub esi, 2                    
		loop L4
		pop esi                       ; restore current position
		mov [esi], ax                ; copy the tested number to [esi]

	L5:
		pop ecx                       ; restore the loop counter 
		loop L1

    endSorting:
        mov ebx, 2
        call PrintArray
    
    ret

InsertionSort_WORD endp


InsertionSort_BYTE proc USES ebx

	mov ecx, count
	dec ecx

	L1:                                           
		push ecx                      ; store the loop counter
		mov eax, ecx
		mov esi, OFFSET byteArr
		mov ecx, count
		sub ecx, eax                  ; calculate number of loops
		mov eax, ecx
		mov edx, 1
		mul edx
		add esi, eax                  ; calculate address of tested number
		mov al, [esi]                ; store the number to compare		
		mov esi, OFFSET byteArr           ; restore esi to the beginning 

	L2:                               
		cmp al, [esi]                ; if that number is less
		jl L3                         ; jump to next part
		add esi, 1                    
		loop L2                       ; if not
		jmp L5                        ; jump to the end of this loop

	L3:
		push esi                      ; store current position
		push eax
		mov eax, ecx
		mov edx, 1
		mul edx
		add esi, eax                  ; move to position of tested number
		pop eax

	L4:
		mov dl, [esi - 1]            ; copy the values to next position
		mov [esi], dl
		sub esi, 1                    
		loop L4
		pop esi                       ; restore current position
		mov [esi], al                ; copy the tested number to [esi]

	L5:
		pop ecx                       ; restore the loop counter 
		loop L1

    endSorting:
        mov ebx, 1
        call PrintArray
    
    ret

InsertionSort_BYTE endp

; pancake sort visual: https://www.youtube.com/watch?v=kk-_DDgoXfk

COMMENT @ start w/ current size equal to number of elements
reduce currSize by 1 while currSize > 1 
for every currSize:
    find index of max element in array till currSize - 1
    flip the array for max element found
    flip the array for element at currSize - 1
@

PancakeSort proc USES ebx

    cmp ebx, 4
    je dwordd

    cmp ebx, 2
    je wordd

    cmp ebx, 1
    je bytee

    ret

    dwordd:
        call PrintArray
        call crlf
        lea edx, displayNewArr
        call writestring
        call crlf
        call PancakeSort_DWORD
    
        ret

    wordd:
        call PrintArray
        call crlf
        lea edx, displayNewArr
        call writestring
        call crlf
        call PancakeSort_WORD
        
        ret

    bytee:
        call PrintArray
        call crlf
        lea edx, displayNewArr
        call writestring
        call crlf
        call PancakeSort_BYTE
        
        ret

PancakeSort endp

PancakeSort_DWORD proc USES ebx

    push ebp
    mov ebp, esp
    push ebx                        ; for printing data later on

    mov ecx, count                  ; currSize
    lea ebx, dwordArr               ; pointing to the first element in the array

    sorting:
        cmp ecx, 1
        jle endd                        ; exit if array is sorted completely

        mov esi, 0                      ; initialize indices for finding max
        mov edi, 1
        mov eax, [dwordArr + esi * 4]   ; initialize max value with the first element
        mov edx, esi                    ; maxIndex = 0

        findMax:
            cmp edi, ecx
            jge maxFound                    ; exit loop if all elements have been traversed thru
            mov ebx, [dwordArr + edi * 4]
            cmp eax, ebx
            jge skipUpdation
            mov eax, ebx                    ; update max value
            mov edx, edi                    ; update maxIndex
        
        skipUpdation:
            inc edi
            jmp findMax

        maxFound:
            ; edx = maxIndex
            cmp edx, ecx
            je sortingStep                  ; maxIndex == currSize - 1 -> skip to next size

        ; flipping from 0 to maxIndex
            mov esi, 0
        flipToMax:
            cmp esi, edx
            jge flipToEnd                   ; done flipping till maxIndex
            mov eax, [dwordArr + esi * 4]
            mov ebx, [dwordArr + edx * 4]
            mov [dwordArr + esi * 4], ebx
            mov [dwordArr + edx * 4], eax
            inc esi
            dec edx
            jmp flipToMax

        flipToEnd:
            mov esi, 0
            mov edi, ecx
            dec edi                         ; currSize - 1

        flipArray:
            cmp esi, edi
            jge sortingStep                 ; done flipping till currSize - 1
            mov eax, [dwordArr + esi * 4]
            mov ebx, [dwordArr + edi * 4]
            mov [dwordArr + esi * 4], ebx
            mov [dwordArr + edi * 4], eax
            inc esi
            dec edi
            jmp flipArray

        sortingStep:
            dec ecx                         ; --currSize
            jmp sorting

    endd:
        ; resetting ebx
        pop ebx
        call PrintArray
    
    pop ebp
    ret

PancakeSort_DWORD endp

PancakeSort_WORD proc USES ebx

    push ebp
    mov ebp, esp
    push ebx                        ; for printing data later on

    mov ecx, count                  ; currSize
    lea ebx, wordArr                ; pointing to the first element in the array

    sorting:
        cmp ecx, 1
        jle endd                        ; exit if array is sorted completely

        mov esi, 0                      ; initialize indices for finding max
        mov edi, 1
        mov ax, [wordArr + esi * 2]   ; initialize max value with the first element
        mov edx, esi                    ; maxIndex = 0

        findMax:
            cmp edi, ecx
            jge maxFound                    ; exit loop if all elements have been traversed thru
            mov bx, [wordArr + edi * 2]
            cmp ax, bx
            jge skipUpdation
            mov ax, bx                      ; update max value
            mov edx, edi                    ; update maxIndex
        
        skipUpdation:
            inc edi
            jmp findMax

        maxFound:
            ; edx = maxIndex
            cmp edx, ecx
            je sortingStep                  ; maxIndex == currSize - 1 -> skip to next size

        ; flipping from 0 to maxIndex
            mov esi, 0
        flipToMax:
            cmp esi, edx
            jge flipToEnd                   ; done flipping till maxIndex
            mov ax, [wordArr + esi * 2]
            mov bx, [wordArr + edx * 2]
            mov [wordArr + esi * 2], bx
            mov [wordArr + edx * 2], ax
            inc esi
            dec edx
            jmp flipToMax

        flipToEnd:
            mov esi, 0
            mov edi, ecx
            dec edi                         ; currSize - 1

        flipArray:
            cmp esi, edi
            jge sortingStep                 ; done flipping till currSize - 1
            mov ax, [wordArr + esi * 2]
            mov bx, [wordArr + edi * 2]
            mov [wordArr + esi * 2], bx
            mov [wordArr + edi * 2], ax
            inc esi
            dec edi
            jmp flipArray

        sortingStep:
            dec ecx                         ; --currSize
            jmp sorting

    endd:
        ; resetting ebx
        pop ebx
        call PrintArray
    
    pop ebp
    ret

PancakeSort_WORD endp

PancakeSort_BYTE proc USES ebx

    push ebp
    mov ebp, esp
    push ebx                        ; for printing data later on

    mov ecx, count                  ; currSize
    lea ebx, byteArr                ; pointing to the first element in the array

    sorting:
        cmp ecx, 1
        jle endd                        ; exit if array is sorted completely

        mov esi, 0                      ; initialize indices for finding max
        mov edi, 1
        mov al, [byteArr + esi]         ; initialize max value with the first element
        mov edx, esi                    ; maxIndex = 0

        findMax:
            cmp edi, ecx
            jge maxFound                    ; exit loop if all elements have been traversed thru
            mov bl, [byteArr + edi]
            cmp al, bl
            jge skipUpdation
            mov al, bl                      ; update max value
            mov edx, edi                    ; update maxIndex
        
        skipUpdation:
            inc edi
            jmp findMax

        maxFound:
            ; edx = maxIndex
            cmp edx, ecx
            je sortingStep                  ; maxIndex == currSize - 1 -> skip to next size

        ; flipping from 0 to maxIndex
            mov esi, 0
        flipToMax:
            cmp esi, edx
            jge flipToEnd                   ; done flipping till maxIndex
            mov al, [byteArr + esi]
            mov bl, [byteArr + edx]
            mov [byteArr + esi], bl
            mov [byteArr + edx], al
            inc esi
            dec edx
            jmp flipToMax

        flipToEnd:
            mov esi, 0
            mov edi, ecx
            dec edi                         ; currSize - 1

        flipArray:
            cmp esi, edi
            jge sortingStep                 ; done flipping till currSize - 1
            mov al, [byteArr + esi]
            mov bl, [byteArr + edi]
            mov [byteArr + esi], bl
            mov [byteArr + edi], al
            inc esi
            dec edi
            jmp flipArray

        sortingStep:
            dec ecx                         ; --currSize
            jmp sorting

    endd:
        ; resetting ebx
        pop ebx
        call PrintArray
    
    pop ebp
    ret

PancakeSort_BYTE endp

PrintArray proc USES ebx

    cmp ebx, 4
    je printDWORD

    cmp ebx, 2
    je printWORD

    cmp ebx, 1
    je printBYTE

    printDWORD:
        mov ecx, LENGTHOF dwordArr
        mov esi, 0

    printLoop1:
        mov eax, dwordArr[esi * TYPE dwordArr]
        call writedec
        mov eax, ' '
        call writechar
        inc esi
        loop printLoop1
        jmp endPrint

    printWORD:
        mov ecx, LENGTHOF wordArr
        mov esi, 0

    printLoop2:
        mov ax, wordArr[esi * TYPE wordArr]
        call writedec
        mov eax, ' '
        call writechar
        inc esi
        loop printLoop2
        jmp endPrint

    printBYTE:
        mov ecx, LENGTHOF byteArr
        mov esi, 0

    printLoop3:
        mov al, byteArr[esi * TYPE byteArr]
        call writedec
        mov eax, ' '
        call writechar
        inc esi
        loop printLoop3
        jmp endPrint

    endPrint:
        call crlf
        ret

PrintArray endp

end main