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
        call MergeSort
        jmp endSort

    callQuickSort:
        call QuickSort_dword
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

    mov ecx, LENGTHOF dwordArr      ; outer loop counter
    dec ecx

    outerLoop:
        mov esi, 0
        mov edi, ecx                ;storing outer loop counter

    innerLoop:
        mov eax, [dwordArr + esi * TYPE dwordArr]       ;compare arr[i] n arr[i+1]
        inc esi
        mov ebx, [dwordArr + esi * TYPE dwordArr]
        dec esi

        cmp eax, ebx
        jle noSwapping                                  ; arr[i] <= arr[i+1] skip swapping

        ; swap if greater
        mov [dwordArr + esi * TYPE dwordArr], ebx
        inc esi
        mov [dwordArr + esi * TYPE dwordArr], eax
        dec esi

    noSwapping:
        inc esi
        dec edi                                         ; dec innerloop counter as we move on to next index
        jnz innerLoop

        dec ecx                                         ;if innerloop counter == 0, we dec outerloop counter 
        jnz outerLoop                                   ; if outerLoop counetr == 0, bubble sort complete!!
        
        
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


; sir i tried my best but i can't get my merge sort code to work :( i'm sorry

;i'll include the pseudocode below in the comments !!

MergeSort proc USES ebx
    call SelectionSort

COMMENT !

    mov ecx , 0         ; low index (left)
    mov edx , count     ; right index (high)
    dec edx             ; count - 1 is passed
    push edx
    push ecx

    call MergeSort


    MergeSort proc 
        
        push ebp        ;stack frame
        mov ebp,esp 

        mov eax, [ebp + 8]   ;eax  = low index (left)
        mov edx, [ebp + 12]  ; edx = high index (right)

        ;base case (if low >= high) then return
        cmp eax,edx
        JGE stopRecursion

        ;calc mid index 
        ; mid = (low + high) / 2
        mov ecx,eax
        add ecx,edx
        shr ecx,1            ; div by 2

        ; call MergeSort again
        push ecx             ; push mid index value as high
        push eax             ; push low
        call MergeSort
        add esp, 8           ; cleaning the stack frame

        ;recursive call for other half
        push edx             ; push right
        inc ecx
        push ecx             ; pushign mid + 1 as low index
        call MergeSort
        add esp,8           

        ;now calling merge function to merge the two halves
        ; merge(arr,low,mid,high)

        push edx             ; pushing high
        push ecx             ; mid
        push [ebp + 8]       ; low 

        call merge
        add esp,12           ; clean stack frame


        stopRecursion:
            pop ebp
    ret 
    MergeSort endp


    merge proc
        
        ; l, mid and r on stack
        push ebp
        mov ebp,esp

        mov eax,[ebp+8]     ;low
        mov ecx,[ebp+12]    ;mid
        mov edx,[ebp+16]    ;high

        ;pointers that will traverse the array
        mov esi,eax         ; i = low
        mov edi,ecx         
        inc ecx             ;j = mid + 1
        mov ebx,eax         ;k = low   

        LoopToMerge:
            ;compare n merge the elements

            cmp esi,ecx
            ; if i > mid  merge right part
            JG CopyRight

            cmp edi,edx
            ;if j(mid+1) > high , merge left
            JG CopyLeft

            ;if both are skipped then compare arr[i] and arr[j]
            mov eax, dwordArr [ esi * TYPE dwordArr]
            mov ebp , dwordArr [edi * TYPE dwordArr]
            cmp eax,ebp
            JLE CopyLeft

            ; if above condition nto satistfied, copy arr[j] to tempArr[k]
            mov tempArray[ebx * TYPE tempArr],ebp
            inc edi
            
            ;now increment k and loop thru mergeloop again
            jmp incK

            
            CopyLeft:
                ;copy arr[i] to tempArr[k]
                mov tempArr [ebx *TYPE tempArr] , eax
                inc esi

            incK:
                inc ebx
                JMP LoopToMerge

            CopyRight:
                ; copy elements that are remainign frm right arr (j to r)
                cmp edi,edx
                jg DoneCopying

                mov eax, dwordArr[edi * TYPE dwordArr]   ;arr[j]
                mov tempArr[ebx * TYPE tempArr] , eax    ;copy to temp[k]
                inc edi                                  ;inc j
                inc ebx                                  ; inc k
                JMP CopyRight  


                CopyLeftFINAL:
                    ;i to mid elements
                    cmp esi,ecx
                    JG DoneCopying  ;if i> mid, left array also done

                    mov eax, dwordArr[esi * TYPE dwordArr]   ;arr[i]
                    mov tempArr[ebx * TYPE tempArr] , eax    ;copy to temp[k]
                    inc esi                                  ;inc j
                    inc ebx                                  ; inc k
                    JMP CopyLeftFINAL                           


                DoneCopying:
                    ; sorted tempArr copied to original
                    mov esi , [ebp + 8]  ;low
                    mov edi , esi        ; dest ptr
                    mov ebx , esi        ; src ptr

                    cmp esi , [ebp + 16] ;comparing with high
                    JG exitt  ;mergign done

                    CopyLoop:
                        mov eax, tempArr [ebx * TYPE tempArr]
                        mov dwordArr[edi * TYPE dwordArr] ,eax
                        inc edi
                        inc ebx
                        cmp edi, [ebp + 16]  ;if we're on last index
                        JLE CopyLoop
 
    ret
    merge endp

!

ret 
MergeSort endp


; Quick Sort Functions
QuickSort proc USES ebx
    
    call PrintArray
    mov edx, offset displayNewArr
    call writestring 
    call crlf
    cmp ebx, 4
    je QuickSort_DWORD

    cmp ebx, 2
    je QuickSort_WORD

    cmp ebx, 1
    je QuickSort_BYTE

    ret
QuickSort ENDP

QuickSort_DWORD PROC
    lea esi, dwordArr  
    mov ecx, LENGTHOF dwordArr
    call QuickSort_Helper
    mov ebx , 4
    call PrintArray
    ret
QuickSort_DWORD endp

QuickSort_WORD PROC
      lea esi, [wordArr]      ; ESI now points to the start of wordArr
    mov ecx, LENGTHOF wordArr
    call QuickSort_Helper_Word
    mov ebx , 2
    call PrintArray
    ret
QuickSort_WORD endp

QuickSort_BYTE PROC
    lea esi, byteArr
    mov ecx, LENGTHOF byteArr
    call QuickSort_Helper_Byte
    mov ebx , 1
    call PrintArray
    ret
QuickSort_BYTE endp

QuickSort_Helper PROC
    ; Parameters: ESI points to the array, ECX is the length of the array

    ; Base Case: If the array has 1 or fewer elements, return
    cmp ecx, 1
    jle endQuickSort

    ; Pivot: Use the last element as the pivot
    mov edi, ecx
    dec edi                           ; edi = ecx - 1
    mov eax, [esi + edi * TYPE dwordArr] ; Load pivot into eax
    xor ebx, ebx                      ; Initialize index for smaller element
    xor edx, edx                      ; Initialize current element index

partitionLoop:
    cmp edx, edi                      ; Check if edx < pivot index
    jge swapPivot                     ; If not, go to pivot swapping

    ; Compare the current element with the pivot
    mov ebp, [esi + edx * TYPE dwordArr] ; Load current element
    cmp ebp, eax
    jg continueLoop                   ; Skip if current element > pivot

    ; Swap current element with element at 'ebx'
    mov ebp, [esi + ebx * TYPE dwordArr]
    push ecx
    mov ecx ,  [esi + edx * TYPE dwordArr]
    mov [esi + ebx * TYPE dwordArr],ecx

    pop ecx
    mov [esi + edx * TYPE dwordArr], ebp
    inc ebx                           ; Increment index for smaller element

continueLoop:
    inc edx                           ; Move to the next element
    jmp partitionLoop

swapPivot:
    ; Swap pivot with the element at index 'ebx'
    mov ebp, [esi + ebx * TYPE dwordArr] ; Load value at 'ebx'
    mov [esi + ebx * TYPE dwordArr], eax ; Place pivot at 'ebx'
    mov [esi + edi * TYPE dwordArr], ebp ; Place value at 'ebx' into pivot position

    ; Save the stack state
    push ecx                          ; Save current length
    push esi                          ; Save pointer to the array

    ; Recursively sort the left partition
    mov ecx, ebx                      ; Length of the left partition
    call QuickSort_Helper             ; Sort left partition

    ; Restore the stack state
    pop esi                           ; Restore array pointer
    pop ecx                           ; Restore length

    ; Recursively sort the right partition
    sub ecx, ebx                      ; Length of the right partition
    dec ecx                           ; Exclude the pivot
    jle endQuickSort                  ; Skip if no right partition
    push ecx
    mov ecx , ebx
    inc ecx
    lea esi, [esi + (ecx) * TYPE dwordArr] ; Move to the right partition
    pop ecx
    call QuickSort_Helper             ; Sort right partition

endQuickSort:
    
    ret
QuickSort_Helper ENDP

QuickSort_Helper_Word PROC
   ; Parameters: ESI points to the array, ECX is the length of the array

    ; Base Case: If the array has 1 or fewer elements, return
    cmp ecx, 1
    jle endQuickSort

    ; Pivot: Use the last element as the pivot
    mov edi, ecx
    dec edi                           ; edi = ecx - 1
    mov eax, [esi + edi * TYPE wordArr] ; Load pivot into eax
    xor ebx, ebx                      ; Initialize index for smaller element
    xor edx, edx                      ; Initialize current element index

partitionLoop:
    cmp edx, edi                      ; Check if edx < pivot index
    jge swapPivot                     ; If not, go to pivot swapping

    ; Compare the current element with the pivot
    mov ebp, [esi + edx * TYPE wordArr] ; Load current element
    cmp ebp, eax
    jg continueLoop                   ; Skip if current element > pivot

    ; Swap current element with element at 'ebx'
    mov ebp, [esi + ebx * TYPE wordArr]
    push ecx
    mov ecx ,  [esi + edx * TYPE wordArr]
    mov [esi + ebx * TYPE wordArr],ecx

    pop ecx
    mov [esi + edx * TYPE wordArr], ebp
    inc ebx                           ; Increment index for smaller element

continueLoop:
    inc edx                           ; Move to the next element
    jmp partitionLoop

swapPivot:
    ; Swap pivot with the element at index 'ebx'
    mov ebp, [esi + ebx * TYPE wordArr] ; Load value at 'ebx'
    mov [esi + ebx * TYPE wordArr], eax ; Place pivot at 'ebx'
    mov [esi + edi * TYPE wordArr], ebp ; Place value at 'ebx' into pivot position

    ; Save the stack state
    push ecx                          ; Save current length
    push esi                          ; Save pointer to the array

    ; Recursively sort the left partition
    mov ecx, ebx                      ; Length of the left partition
    call QuickSort_Helper_Word             ; Sort left partition

    ; Restore the stack state
    pop esi                           ; Restore array pointer
    pop ecx                           ; Restore length

    ; Recursively sort the right partition
    sub ecx, ebx                      ; Length of the right partition
    dec ecx                           ; Exclude the pivot
    jle endQuickSort                  ; Skip if no right partition
    push ecx
    mov ecx , ebx
    inc ecx
    lea esi, [esi + (ecx) * TYPE wordArr] ; Move to the right partition
    pop ecx
    call QuickSort_Helper_Word            ; Sort right partition

endQuickSort:
    mov ebx,2
    call PrintArray
    ret
QuickSort_Helper_Word ENDP

QuickSort_Helper_Byte PROC
    ; Parameters: ESI points to the array, ECX is the length of the array

    ; Base Case: If the array has 1 or fewer elements, return
    cmp ecx, 1
    jle endQuickSort
    
    ; Pivot: Use the last element as the pivot
    mov edi, ecx
    dec edi                           ; edi = ecx - 1
    mov eax, [esi + edi * TYPE byteArr] ; Load pivot into eax
    xor ebx, ebx                      ; Initialize index for smaller element
    xor edx, edx                      ; Initialize current element index

partitionLoop:
    cmp edx, edi                      ; Check if edx < pivot index
    jge swapPivot                     ; If not, go to pivot swapping

    ; Compare the current element with the pivot
    mov ebp, [esi + edx * TYPE byteArr] ; Load current element
    cmp ebp, eax
    jg continueLoop                   ; Skip if current element > pivot

    ; Swap current element with element at 'ebx'
    mov ebp, [esi + ebx * TYPE byteArr]
    push ecx
    mov ecx ,  [esi + edx * TYPE byteArr]
    mov [esi + ebx * TYPE byteArr],ecx

    pop ecx
    mov [esi + edx * TYPE byteArr], ebp
    inc ebx                           ; Increment index for smaller element

continueLoop:
    inc edx                           ; Move to the next element
    jmp partitionLoop

swapPivot:
    ; Swap pivot with the element at index 'ebx'
    mov ebp, [esi + ebx * TYPE byteArr] ; Load value at 'ebx'
    mov [esi + ebx * TYPE byteArr], eax ; Place pivot at 'ebx'
    mov [esi + edi * TYPE byteArr], ebp ; Place value at 'ebx' into pivot position

    ; Save the stack state
    push ecx                          ; Save current length
    push esi                          ; Save pointer to the array

    ; Recursively sort the left partition
    mov ecx, ebx                      ; Length of the left partition
    call QuickSort_Helper_Byte             ; Sort left partition

    ; Restore the stack state
    pop esi                           ; Restore array pointer
    pop ecx                           ; Restore length

    ; Recursively sort the right partition
    sub ecx, ebx                      ; Length of the right partition
    dec ecx                           ; Exclude the pivot
    jle endQuickSort                  ; Skip if no right partition
    push ecx
    mov ecx , ebx
    inc ecx
    lea esi, [esi + (ecx) * TYPE byteArr] ; Move to the right partition
    pop ecx
    call QuickSort_Helper_Byte             ; Sort right partition

endQuickSort:
    ret
QuickSort_Helper_Byte ENDP


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
