.MODEL SMALL

.STACK 100H

.DATA
    ; User Database (Arrays)
    user_accounts DB '1001', '1002', '1003', '1004', '1005', '1006', '1007', '1008', '1009', '1010', '$' ; Account numbers (4 chars each)
    user_pins DB '1234', '5678', '9999', '1111', '2222', '3333', '4444', '5555', '6666', '7777', '$' ; PINs (4 chars each)
    user_balances DW 5000, 3000, 10000, 2000, 4000, 6000, 8000, 1000, 7000, 9000, 0 ; Balances
    user_names DB 'JOHN        ', 'ALICE       ', 'BOB         ', 'CAROL       ', 'DAVID       ', 'EMMA        ', 'FRANK       ', 'GRACE       ', 'HENRY       ', 'ISABEL      ', '$' ; Names (12 chars each)
    user_birthdates DB '12/05/1990', '25/12/1985', '08/03/1992', '15/07/1988', '30/09/1987', '22/11/1991', '10/02/1986', '05/04/1989', '18/06/1990', '01/01/1993', '$' ; Birthdates (10 chars each)
    user_nid DB '123456789', '987654321', '456789123', '111222333', '444555666', '777888999', '222333444', '555666777', '888999111', '333444555', '$' ; NID numbers (9 chars each)
    user_addresses DB 'Dhaka       ','Chittagong  ','Sylhet      ','Rajshahi    ','Khulna      ','Barisal     ','Rangpur     ','Mymensingh  ','Comilla     ','Narayanganj ','$' ; Addresses (12 chars each)

    ; Per-account lock flags (0=ok, 1=locked)
    user_locked DB 0,0,0,0,0,0,0,0,0,0

    ; Per-user Transaction History (10 users, 50 transactions each)
    user_transaction_types DB 50 DUP('$'), 50 DUP('$'), 50 DUP('$'), 50 DUP('$'), 50 DUP('$'), 50 DUP('$'), 50 DUP('$'), 50 DUP('$'), 50 DUP('$'), 50 DUP('$') ; 10 users x 50 bytes
    user_transaction_amounts DW 50 DUP(0), 50 DUP(0), 50 DUP(0), 50 DUP(0), 50 DUP(0), 50 DUP(0), 50 DUP(0), 50 DUP(0), 50 DUP(0), 50 DUP(0) ; 10 users x 50 words
    user_transaction_counts DW 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ; Transaction count per user

    ; Per-user loan counts
    user_loan_counts DW 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

    ; Current session variables
    current_user DW 0
    temp_amount DW 0
    temp_amount2 DW 0                              ; Holds max loan when needed
    login_attempts DB 0

    ; Input buffers
    input_account DB 5, ?, 5 DUP('$')
    input_pin DB 5, ?, 5 DUP('$')
    input_amount DB 6, ?, 6 DUP('$')
    input_name DB 13, ?, 13 DUP('$')              ; Name (max 12 chars)
    input_choice DB 3, ?, 3 DUP('$')              ; Menu choice
    input_address DB 13, ?, 13 DUP('$')           ; Address (max 12 chars)

    ; Menu strings
    welcome_msg DB 13, 10, '=== WELCOME TO ATM SIMULATOR ===', 13, 10, '$'
    login_prompt DB 13, 10, 'Enter Account Number: $'
    pin_prompt DB 13, 10, 'Enter PIN: $'
    welcome_user DB 13, 10, 'Welcome, $'
    main_menu DB 13, 10, 13, 10, '=== MAIN MENU ===', 13, 10
              DB '1. View Balance', 13, 10
              DB '2. Deposit Money', 13, 10
              DB '3. Withdraw Money', 13, 10
              DB '4. Transaction History', 13, 10
              DB '5. View User Info', 13, 10
              DB '6. Update PIN / Name / Address', 13, 10
              DB '7. Apply for Loan (show eligibility)', 13, 10
              DB '8. Logout', 13, 10
              DB 'Choice: $'
    invalid_choice_msg DB 13, 10, 'Please choose valid option', 13, 10, '$'

    ; Messages
    invalid_login1 DB 13, 10, 'Invalid PIN!', 13, 10, '$'
    invalid_login2 DB 13, 10, 'Invalid Account Number!', 13, 10, '$'
    account_locked_msg DB 13,10,'Account is locked due to more than 3 wrong attempts.dhuru',13,10,'$'
    login_success DB 13, 10, 'Login Successful!', 13, 10, '$'
    balance_msg DB 13, 10, 'Current Balance: $'
    deposit_prompt DB 13, 10, 'Enter deposit amount: $'
    withdraw_prompt DB 13, 10, 'Enter withdrawal amount: $'
    insufficient_funds DB 13, 10, 'Insufficient funds!', 13, 10, '$'
    transaction_success DB 13, 10, 'Transaction successful!', 13, 10, '$'
    goodbye_msg DB 13, 10, 'Thank you for using ATM!', 13, 10, '$'
    newline DB 13, 10, '$'

    ; Loan texts
    loan_msg DB 13, 10, 'Loan eligibility: 2x your balance = $'
    loan_eligible_line1 DB 13,10,'You are applicable for loan.',13,10,'$'
    loan_max_prefix DB 'Maximum you can take: $'
    loan_inline_prompt DB 13,10,'1. Take Loan - Yes',13,10,'2. Take Loan - No',13,10,'Choice: $'
    not_eligible_msg DB 13,10,'You are not applicable for loan.',13,10,'$'
    loan_contact_msg DB 13,10,'If you are interested for loan talk to our customer care 01567',13,10,'$' ; kept but not used after YES
    loan_taken_msg DB 13,10,'Loan taken: $', '$'
    loan_cancelled_msg DB 13,10,'Loan not taken.',13,10,'$'
    new_balance_msg DB 13,10,'New balance: $', '$'
    loan_enter_amount DB 13,10,'Enter loan amount: $'
    loan_exceed_prefix DB 13,10,'You cant take ', '$'
    loan_exceed_suffix DB ' more than this',13,10,'$'
    LOAN_MIN_BALANCE DW 1000

    ; Update menu strings
    update_menu_header DB 13,10,'=== UPDATE MENU ===',13,10,'$'
    update_menu_items DB '1. Change PIN',13,10,'2. Change Name',13,10,'3. Change Address',13,10,'Choice: $'
    update_pin_prompt DB 13,10,'Enter NEW PIN (4 digits): $'
    pin_updated DB 13,10,'PIN updated successfully!',13,10,'$'
    update_name_prompt DB 13,10,'Enter NEW Name (3-12 chars, letters only): $'
    name_updated DB 13,10,'Name updated successfully!',13,10,'$'
    update_address_prompt DB 13,10,'Enter NEW Address (3-12 chars, letters only): $'
    address_updated DB 13,10,'Address updated successfully!',13,10,'$'
    invalid_pin_msg DB 13,10,'Invalid PIN! Must be exactly 4 digits.',13,10,'$'
    invalid_name_msg DB 13,10,'Invalid Name! Must be 3-12 characters, letters only.',13,10,'$'
    invalid_address_msg DB 13,10,'Invalid Address! Must be 3-12 characters, letters only.',13,10,'$'

    ; User Info Display Messages
    user_info_header DB 13, 10, '=== USER INFORMATION ===', 13, 10, '$'
    account_label DB 'Account Number: $'
    name_label DB 13, 10, 'Name: $'
    birthdate_label DB 13, 10, 'Birth Date: $'
    nid_label DB 13, 10, 'NID Number: $'
    address_label DB 13, 10, 'Address: $'
    balance_label DB 13, 10, 'Current Balance: $'

    ; Transaction History Messages (labels with no colon)
    history_header DB 13, 10, '=== TRANSACTION HISTORY ===', 13, 10, '$'
    no_transactions DB 'No transactions found.', 13, 10, '$'
    deposit_label  DB 'deposit ', '$'
    withdraw_label DB 'withdraw ', '$'
    loan_history_label DB 'loan ', '$'
    transaction_separator DB ' | ', '$'

.CODE

MAIN PROC
    ; Initialize DS and ES
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX  ; Set ES for string operations

    ; Display welcome message
    LEA DX, welcome_msg
    MOV AH, 09H
    INT 21H

    ; Main program loop
main_loop:
        CALL LOGIN_PROCEDURE
        CMP AX, 1
        JE authenticated
        JMP main_loop

authenticated:
        CALL DISPLAY_USER_WELCOME
        CALL MAIN_MENU_PROCEDURE
        JMP main_loop

    ; Exit to DOS
    MOV AX, 4C00H
    INT 21H
MAIN ENDP

; --- Clear input buffer ---
CLEAR_BUFFER PROC
    PUSH AX
    PUSH CX
    PUSH DI
    MOV DI, DX
    MOV CL, [DI]   ; Load max length into CL
    MOV CH, 0      ; CX = max length
    ADD DI, 2      ; Skip max length and actual length bytes
    MOV AL, '$'
clear_loop:
    JCXZ clear_done
    STOSB
    DEC CX
    JMP clear_loop
clear_done:
    POP DI
    POP CX
    POP AX
    RET
CLEAR_BUFFER ENDP

; --- Find account index by input_account buffer ---
; Returns: AL = 0..9 if found, AL=0FFh if not found
FIND_ACCOUNT_INDEX PROC
    PUSH SI
    PUSH DI
    PUSH CX
    PUSH BX

    MOV AL, 0FFh               ; default = not found
    MOV BX, 0                  ; array byte offset
    MOV DL, 0                  ; candidate index (0..9)

next_acc_cmp:
    CMP DL, 10
    JGE fai_done

    LEA DI, user_accounts
    ADD DI, BX                 ; point to 4-char account
    LEA SI, input_account+2
    MOV CX, 4
acc_cmp_loop:
    LODSB
    CMP AL, [DI]
    JNE acc_not_match
    INC DI
    LOOP acc_cmp_loop

    ; matched
    MOV AL, DL
    JMP fai_done

acc_not_match:
    INC DL
    ADD BX, 4
    JMP next_acc_cmp

fai_done:
    POP BX
    POP CX
    POP DI
    POP SI
    RET
FIND_ACCOUNT_INDEX ENDP

LOGIN_PROCEDURE PROC
    PUSH BX
    PUSH CX
    PUSH DX

    MOV login_attempts, 0

login_retry:
        CMP login_attempts, 3
        JGE login_failed

        ; Get account number
        LEA DX, login_prompt
        MOV AH, 09H
        INT 21H

        LEA DX, input_account
        CALL CLEAR_BUFFER
        LEA DX, input_account
        MOV AH, 0AH
        INT 21H

        ; Check if account exists
        CALL FIND_ACCOUNT_INDEX        ; AL = index or FF
        CMP AL, 0FFh
        JE invalid_account
        ; Validate index range
        CMP AL, 9
        JA invalid_account  ; If index > 9, treat as invalid

        MOV BL, AL

        ; Check if this account is locked
        XOR BH, BH
        LEA SI, user_locked
        ADD SI, BX
        CMP BYTE PTR [SI], 0
        JNE account_locked

        ; Get PIN (hidden input)
        LEA DX, pin_prompt
        MOV AH, 09H
        INT 21H

        LEA DX, input_pin
        CALL CLEAR_BUFFER
        CALL GET_HIDDEN_INPUT

        ; Validate credentials
        CALL VALIDATE_USER
        CMP AX, 1
        JE login_successful

        ; Invalid PIN
        LEA DX, invalid_login1
        MOV AH, 09H
        INT 21H

        ; Increase attempt count
        INC login_attempts
        JMP login_retry

invalid_account:
        LEA DX, invalid_login2
        MOV AH, 09H
        INT 21H
        JMP login_retry

account_locked:
        LEA DX, account_locked_msg
        MOV AH, 09H
        INT 21H
        MOV AX, 0
        JMP login_exit

login_failed:
        ; Lock the account if a valid account was last entered
        CALL FIND_ACCOUNT_INDEX
        CMP AL, 0FFh
        JE skip_lock
        CMP AL, 9
        JA skip_lock  ; Skip if index out of bounds
        MOV BL, AL
        XOR BH, BH
        LEA SI, user_locked
        ADD SI, BX
        MOV BYTE PTR [SI], 1
        LEA DX, account_locked_msg
        MOV AH, 09H
        INT 21H

skip_lock:
        MOV AX, 0
        JMP login_exit

login_successful:
        LEA DX, login_success
        MOV AH, 09H
        INT 21H
        MOV AX, 1

login_exit:
        POP DX
        POP CX
        POP BX
        RET
LOGIN_PROCEDURE ENDP

; --- Get hidden input for PIN ---
GET_HIDDEN_INPUT PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH SI
    PUSH DI

    LEA DI, input_pin+2
    MOV BX, 0                   ; Character count

ghi_loop:
    CMP BX, 4
    JGE ghi_done

    MOV AH, 08H                ; Read char without echo
    INT 21H
    CMP AL, 13                 ; Check for Enter key
    JE ghi_done

    MOV [DI], AL               ; Store char
    INC DI
    INC BX

    MOV DL, '*'                ; Display *
    MOV AH, 02H
    INT 21H

    JMP ghi_loop

ghi_done:
    MOV input_pin+1, BL        ; Store length
    MOV BYTE PTR [DI], '$'     ; Null terminate

    ; If less than 4 chars, pad with $
    CMP BL, 4
    JGE ghi_exit
    MOV CX, 4
    SUB CL, BL
    MOV AL, '$'
ghi_pad_loop:
    JCXZ ghi_exit
    STOSB
    DEC CX
    JMP ghi_pad_loop

ghi_exit:
    LEA DX, newline
    MOV AH, 09H
    INT 21H

    POP DI
    POP SI
    POP CX
    POP BX
    POP AX
    RET
GET_HIDDEN_INPUT ENDP

VALIDATE_USER PROC
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    MOV SI, 0
    MOV BX, 0

validate_loop:
        CMP SI, 10
        JGE validation_failed

        ; Compare account (4)
        PUSH SI
        MOV CX, 4
        LEA DI, user_accounts
        ADD DI, BX
        LEA SI, input_account + 2

compare_account:
        LODSB
        CMP AL, [DI]
        JNE next_user
        INC DI
        LOOP compare_account

        ; Compare PIN (4)
        POP SI
        PUSH SI
        MOV CX, 4
        LEA DI, user_pins
        MOV AX, SI
        MOV DX, 4
        MUL DX
        ADD DI, AX
        LEA SI, input_pin + 2

compare_pin:
        LODSB
        CMP AL, [DI]
        JNE next_user
        INC DI
        LOOP compare_pin

        ; success
        POP SI
        MOV current_user, SI
        MOV AX, 1
        JMP validate_exit

next_user:
        POP SI
        INC SI
        ADD BX, 4
        JMP validate_loop

validation_failed:
        MOV AX, 0

validate_exit:
    POP SI
    POP DX
    POP CX
    POP BX
    RET
VALIDATE_USER ENDP

; ... (rest of the code remains unchanged)

DISPLAY_USER_WELCOME PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    ; "Welcome, "
    LEA DX, welcome_user
    MOV AH, 09H
    INT 21H

    ; name (12 chars)
    MOV AX, current_user
    MOV BX, 12
    MUL BX
    LEA SI, user_names
    ADD SI, AX
    MOV CX, 12
display_name_loop:
    LODSB
    CMP AL, ' '        ; stop at padding
    JE name_display_done
    CMP AL, '$'
    JE name_display_done
    CMP AL, 0
    JE name_display_done
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    LOOP display_name_loop

name_display_done:
    MOV DL, '!'
    MOV AH, 02H
    INT 21H
    LEA DX, newline
    MOV AH, 09H
    INT 21H

    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
DISPLAY_USER_WELCOME ENDP

MAIN_MENU_PROCEDURE PROC
    PUSH AX
    PUSH BX
    PUSH DX
    PUSH SI

menu_loop:
        LEA DX, main_menu
        MOV AH, 09H
        INT 21H

        LEA DX, input_choice
        CALL CLEAR_BUFFER
        LEA DX, input_choice
        MOV AH, 0AH
        INT 21H

        ; Check if input is exactly one character
        MOV BL, input_choice+1
        CMP BL, 1
        JNE invalid_choice

        LEA SI, input_choice+2
        LODSB

        ; Validate choice is between '1' and '8'
        CMP AL, '1'
        JB invalid_choice
        CMP AL, '8'
        JA invalid_choice

        CMP AL, '1'
        JE view_balance
        CMP AL, '2'
        JE deposit_money
        CMP AL, '3'
        JE withdraw_money
        CMP AL, '4'
        JE view_history
        CMP AL, '5'
        JE view_user_info
        CMP AL, '6'
        JE update_info
        CMP AL, '7'
        JE apply_loan
        CMP AL, '8'
        JE logout

invalid_choice:
        LEA DX, invalid_choice_msg
        MOV AH, 09H
        INT 21H
        JMP menu_loop

view_balance:
        CALL VIEW_BALANCE_PROC
        JMP menu_loop

deposit_money:
        CALL DEPOSIT_PROC
        JMP menu_loop

withdraw_money:
        CALL WITHDRAW_PROC
        JMP menu_loop

view_history:
        CALL VIEW_HISTORY_PROC
        JMP menu_loop

view_user_info:
        CALL VIEW_USER_INFO_PROC
        JMP menu_loop

update_info:
        CALL UPDATE_MENU_PROC
        JMP menu_loop

apply_loan:
        CALL LOAN_PROC
        JMP menu_loop

logout:
        LEA DX, goodbye_msg
        MOV AH, 09H
        INT 21H
        CALL CLEAR_SCREEN

    POP SI
    POP DX
    POP BX
    POP AX
    RET
MAIN_MENU_PROCEDURE ENDP

CLEAR_SCREEN PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 07H
    MOV CH, 00H
    MOV CL, 00H
    MOV DH, 24H
    MOV DL, 79H
    INT 10H
    POP DX
    POP CX
    POP BX
    POP AX
    RET
CLEAR_SCREEN ENDP

VIEW_BALANCE_PROC PROC
    PUSH AX
    PUSH BX
    PUSH DX

    LEA DX, balance_msg
    MOV AH, 09H
    INT 21H

    MOV BX, current_user
    SHL BX, 1
    MOV AX, user_balances[BX]
    CALL DISPLAY_NUMBER

    LEA DX, newline
    MOV AH, 09H
    INT 21H

    POP DX
    POP BX
    POP AX
    RET
VIEW_BALANCE_PROC ENDP

VIEW_USER_INFO_PROC PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    LEA DX, user_info_header
    MOV AH, 09H
    INT 21H

    ; Account
    LEA DX, account_label
    MOV AH, 09H
    INT 21H
    MOV AX, current_user
    MOV BX, 4
    MUL BX
    LEA SI, user_accounts
    ADD SI, AX
    MOV CX, 4
display_account:
    LODSB
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    LOOP display_account

    ; Name
    LEA DX, name_label
    MOV AH, 09H
    INT 21H
    MOV AX, current_user
    MOV BX, 12
    MUL BX
    LEA SI, user_names
    ADD SI, AX
    MOV CX, 12
display_name_info:
    LODSB
    CMP AL, ' '
    JE name_done
    CMP AL, '$'
    JE name_done
    CMP AL, 0
    JE name_done
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    LOOP display_name_info
name_done:

    ; Birth Date
    LEA DX, birthdate_label
    MOV AH, 09H
    INT 21H
    MOV AX, current_user
    MOV BX, 10
    MUL BX
    LEA SI, user_birthdates
    ADD SI, AX
    MOV CX, 10
display_birthdate:
    LODSB
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    LOOP display_birthdate

    ; NID
    LEA DX, nid_label
    MOV AH, 09H
    INT 21H
    MOV AX, current_user
    MOV BX, 9
    MUL BX
    LEA SI, user_nid
    ADD SI, AX
    MOV CX, 9
display_nid:
    LODSB
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    LOOP display_nid

    ; Address
    LEA DX, address_label
    MOV AH, 09H
    INT 21H
    MOV AX, current_user
    MOV BX, 12
    MUL BX
    LEA SI, user_addresses
    ADD SI, AX
    MOV CX, 12
display_address:
    LODSB
    CMP AL, ' '
    JE addr_done
    CMP AL, '$'
    JE addr_done
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    LOOP display_address
addr_done:

    ; Balance
    LEA DX, balance_label
    MOV AH, 09H
    INT 21H
    MOV BX, current_user
    SHL BX, 1
    MOV AX, user_balances[BX]
    CALL DISPLAY_NUMBER

    LEA DX, newline
    MOV AH, 09H
    INT 21H

    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
VIEW_USER_INFO_PROC ENDP

DEPOSIT_PROC PROC
    PUSH AX
    PUSH BX
    PUSH DX

    LEA DX, deposit_prompt
    MOV AH, 09H
    INT 21H

    LEA DX, input_amount
    CALL CLEAR_BUFFER
    LEA DX, input_amount
    MOV AH, 0AH
    INT 21H

    CALL STRING_TO_NUMBER
    MOV temp_amount, AX

    MOV BX, current_user
    SHL BX, 1
    ADD user_balances[BX], AX

    MOV AL, 'D'
    CALL ADD_TRANSACTION

    LEA DX, transaction_success
    MOV AH, 09H
    INT 21H

    POP DX
    POP BX
    POP AX
    RET
DEPOSIT_PROC ENDP

WITHDRAW_PROC PROC
    PUSH AX
    PUSH BX
    PUSH DX

    LEA DX, withdraw_prompt
    MOV AH, 09H
    INT 21H

    LEA DX, input_amount
    CALL CLEAR_BUFFER
    LEA DX, input_amount
    MOV AH, 0AH
    INT 21H

    CALL STRING_TO_NUMBER
    MOV temp_amount, AX

    MOV BX, current_user
    SHL BX, 1
    CMP AX, user_balances[BX]
    JG insufficient

    SUB user_balances[BX], AX

    MOV AL, 'W'
    CALL ADD_TRANSACTION

    LEA DX, transaction_success
    MOV AH, 09H
    INT 21H
    JMP withdraw_exit

insufficient:
    LEA DX, insufficient_funds
    MOV AH, 09H
    INT 21H

withdraw_exit:
    POP DX
    POP BX
    POP AX
    RET
WITHDRAW_PROC ENDP

UPDATE_MENU_PROC PROC
    PUSH DX
    PUSH AX
    PUSH BX
    PUSH SI

    LEA DX, update_menu_header
    MOV AH, 09H
    INT 21H

    LEA DX, update_menu_items
    MOV AH, 09H
    INT 21H

    LEA DX, input_choice
    CALL CLEAR_BUFFER
    LEA DX, input_choice
    MOV AH, 0AH
    INT 21H

    MOV AL, input_choice+2
    CMP AL, '1'
    JE do_change_pin
    CMP AL, '2'
    JE do_change_name
    CMP AL, '3'
    JE do_change_address
    JMP upd_exit

do_change_pin:
    CALL UPDATE_PIN_PROC
    JMP upd_exit

do_change_name:
    CALL UPDATE_NAME_PROC
    JMP upd_exit

do_change_address:
    CALL UPDATE_ADDRESS_PROC
    JMP upd_exit

upd_exit:
    POP SI
    POP BX
    POP AX
    POP DX
    RET
UPDATE_MENU_PROC ENDP

UPDATE_PIN_PROC PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI

    LEA DX, update_pin_prompt
    MOV AH, 09H
    INT 21H

    LEA DX, input_pin
    CALL CLEAR_BUFFER
    CALL GET_HIDDEN_INPUT

    MOV CL, input_pin+1
    CMP CL, 4
    JNE pin_invalid

    LEA SI, input_pin+2
    MOV CX, 4
validate_pin_loop:
    LODSB
    CMP AL, '0'
    JB pin_invalid
    CMP AL, '9'
    JA pin_invalid
    LOOP validate_pin_loop

    MOV AX, current_user
    MOV BX, 4
    MUL BX
    LEA DI, user_pins
    ADD DI, AX
    LEA SI, input_pin+2
    MOV CX, 4
copy_pin_loop:
    LODSB
    STOSB
    LOOP copy_pin_loop

    LEA DX, pin_updated
    MOV AH, 09H
    INT 21H
    JMP pin_update_exit

pin_invalid:
    LEA DX, invalid_pin_msg
    MOV AH, 09H
    INT 21H

pin_update_exit:
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
UPDATE_PIN_PROC ENDP

UPDATE_NAME_PROC PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI

    LEA DX, update_name_prompt
    MOV AH, 09H
    INT 21H

    LEA DX, input_name
    CALL CLEAR_BUFFER
    LEA DX, input_name
    MOV AH, 0AH
    INT 21H

    MOV BL, input_name+1
    CMP BL, 3
    JB name_invalid
    CMP BL, 12
    JA name_invalid

    ; Validate input: only letters (A-Z, a-z)
    LEA SI, input_name+2
    MOV CL, BL
    MOV CH, 0
validate_name_loop:
    JCXZ name_valid
    LODSB
    CMP AL, 13
    JE name_valid
    CMP AL, 'A'
    JB name_invalid
    CMP AL, 'Z'
    JBE name_letter_ok
    CMP AL, 'a'
    JB name_invalid
    CMP AL, 'z'
    JA name_invalid
name_letter_ok:
    LOOP validate_name_loop

name_valid:
    ; Clear 12-byte name field
    MOV AX, current_user
    MOV BX, 12
    MUL BX
    LEA DI, user_names
    ADD DI, AX
    MOV CX, 12
    MOV AL, ' '
    REP STOSB

    ; Copy new name
    MOV AX, current_user
    MOV BX, 12
    MUL BX
    LEA DI, user_names
    ADD DI, AX
    LEA SI, input_name+2
    MOV CL, BL
    MOV CH, 0
copy_name_loop:
    LODSB
    CMP AL, 13
    JE skip_cr_name
    STOSB
    LOOP copy_name_loop
    JMP name_update_done

skip_cr_name:
    DEC CX
    JMP copy_name_loop

name_update_done:
    LEA DX, name_updated
    MOV AH, 09H
    INT 21H
    JMP name_update_exit

name_invalid:
    LEA DX, invalid_name_msg
    MOV AH, 09H
    INT 21H

name_update_exit:
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
UPDATE_NAME_PROC ENDP

UPDATE_ADDRESS_PROC PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI

    LEA DX, update_address_prompt
    MOV AH, 09H
    INT 21H

    LEA DX, input_address
    CALL CLEAR_BUFFER
    LEA DX, input_address
    MOV AH, 0AH
    INT 21H

    MOV BL, input_address+1
    CMP BL, 3
    JB addr_invalid
    CMP BL, 12
    JA addr_invalid

    ; Validate input: only letters (A-Z, a-z)
    LEA SI, input_address+2
    MOV CL, BL
    MOV CH, 0
validate_address_loop:
    JCXZ addr_valid
    LODSB
    CMP AL, 13
    JE addr_valid
    CMP AL, 'A'
    JB addr_invalid
    CMP AL, 'Z'
    JBE addr_letter_ok
    CMP AL, 'a'
    JB addr_invalid
    CMP AL, 'z'
    JA addr_invalid
addr_letter_ok:
    LOOP validate_address_loop

addr_valid:
    ; Clear 12-byte address field
    MOV AX, current_user
    MOV BX, 12
    MUL BX
    LEA DI, user_addresses
    ADD DI, AX
    MOV CX, 12
    MOV AL, ' '
    REP STOSB

    ; Copy new address
    MOV AX, current_user
    MOV BX, 12
    MUL BX
    LEA DI, user_addresses
    ADD DI, AX
    LEA SI, input_address+2
    MOV CL, BL
    MOV CH, 0
copy_addr_loop:
    LODSB
    CMP AL, 13
    JE skip_cr_addr
    STOSB
    LOOP copy_addr_loop
    JMP addr_update_done

skip_cr_addr:
    DEC CX
    JMP copy_addr_loop

addr_update_done:
    LEA DX, address_updated
    MOV AH, 09H
    INT 21H
    JMP addr_update_exit

addr_invalid:
    LEA DX, invalid_address_msg
    MOV AH, 09H
    INT 21H

addr_update_exit:
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
UPDATE_ADDRESS_PROC ENDP

LOAN_PROC PROC
    PUSH AX
    PUSH BX
    PUSH DX
    PUSH SI

    MOV BX, current_user
    SHL BX, 1
    MOV AX, user_balances[BX]

    CMP AX, LOAN_MIN_BALANCE
    JB loan_not_eligible

    LEA SI, user_loan_counts
    ADD SI, BX
    CMP WORD PTR [SI], 2
    JGE loan_not_eligible

    LEA DX, loan_eligible_line1
    MOV AH, 09H
    INT 21H

    LEA DX, loan_max_prefix
    MOV AH, 09H
    INT 21H

    MOV AX, user_balances[BX]
    SHL AX, 1
    MOV temp_amount2, AX
    CALL DISPLAY_NUMBER

    LEA DX, newline
    MOV AH, 09H
    INT 21H

    LEA DX, loan_inline_prompt
    MOV AH, 09H
    INT 21H

    LEA DX, input_choice
    CALL CLEAR_BUFFER
    LEA DX, input_choice
    MOV AH, 0AH
    INT 21H

    MOV AL, input_choice+2
    CMP AL, '1'
    JE do_take_loan
    CMP AL, '2'
    JE do_cancel_loan
    JMP loan_done

do_take_loan:
    CALL TAKE_LOAN_YES_PROC
    JMP loan_done

do_cancel_loan:
    CALL TAKE_LOAN_NO_PROC
    JMP loan_done

loan_not_eligible:
    LEA DX, not_eligible_msg
    MOV AH, 09H
    INT 21H

loan_done:
    POP SI
    POP DX
    POP BX
    POP AX
    RET
LOAN_PROC ENDP

TAKE_LOAN_YES_PROC PROC
    PUSH AX
    PUSH BX
    PUSH DX
    PUSH SI

    MOV BX, current_user
    SHL BX, 1
    MOV AX, user_balances[BX]

    CMP AX, LOAN_MIN_BALANCE
    JB not_eligible_here

    LEA SI, user_loan_counts
    ADD SI, BX
    CMP WORD PTR [SI], 2
    JGE not_eligible_here

    MOV AX, user_balances[BX]
    SHL AX, 1
    MOV temp_amount2, AX

    LEA DX, loan_enter_amount
    MOV AH, 09H
    INT 21H

    LEA DX, input_amount
    CALL CLEAR_BUFFER
    LEA DX, input_amount
    MOV AH, 0AH
    INT 21H

    CALL STRING_TO_NUMBER
    MOV temp_amount, AX

    MOV DX, temp_amount
    CMP DX, temp_amount2
    JBE do_take

    LEA DX, loan_exceed_prefix
    MOV AH, 09H
    INT 21H
    MOV AX, temp_amount2
    CALL DISPLAY_NUMBER
    LEA DX, loan_exceed_suffix
    MOV AH, 09H
    INT 21H
    JMP loan_yes_exit

do_take:
    MOV AX, temp_amount
    ADD user_balances[BX], AX
    MOV AL, 'L'
    CALL ADD_TRANSACTION

    LEA DX, loan_taken_msg
    MOV AH, 09H
    INT 21H
    MOV AX, temp_amount
    CALL DISPLAY_NUMBER
    LEA DX, newline
    MOV AH, 09H
    INT 21H

    LEA DX, new_balance_msg
    MOV AH, 09H
    INT 21H
    MOV AX, user_balances[BX]
    CALL DISPLAY_NUMBER
    LEA DX, newline
    MOV AH, 09H
    INT 21H
    JMP loan_yes_exit

not_eligible_here:
    LEA DX, not_eligible_msg
    MOV AH, 09H
    INT 21H

loan_yes_exit:
    POP SI
    POP DX
    POP BX
    POP AX
    RET
TAKE_LOAN_YES_PROC ENDP

TAKE_LOAN_NO_PROC PROC
    PUSH DX
    LEA DX, loan_cancelled_msg
    MOV AH, 09H
    INT 21H
    POP DX
    RET
TAKE_LOAN_NO_PROC ENDP

ADD_TRANSACTION PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH SI

    MOV CH, AL       ; save original transaction type ('D'/'W'/'L')

    ; Per-user transaction history
    MOV BX, current_user
    SHL BX, 1
    LEA SI, user_transaction_counts
    ADD SI, BX
    MOV BX, [SI]                 ; BX = current user's transaction count
    CMP BX, 50
    JGE transaction_full

    ; Store transaction type (index = user*50 + BX)
    MOV AX, current_user
    MOV DX, 50
    MUL DX                        ; AX = user*50
    LEA SI, user_transaction_types
    ADD SI, AX
    ADD SI, BX
    MOV AL, CH                    ; restore saved type
    MOV [SI], AL

    ; Store transaction amount (index = user*100 + BX*2)
    MOV AX, current_user
    MOV DX, 100                   ; 50 * 2 bytes
    MUL DX                        ; AX = user*100
    LEA SI, user_transaction_amounts
    ADD SI, AX
    SHL BX, 1
    ADD SI, BX
    MOV AX, temp_amount
    MOV [SI], AX

    ; Increment user's transaction count
    MOV BX, current_user
    SHL BX, 1
    LEA SI, user_transaction_counts
    ADD SI, BX
    INC WORD PTR [SI]

    ; Increment loan count if 'L'
    CMP CH, 'L'
    JNE transaction_full
    LEA SI, user_loan_counts
    ADD SI, BX
    INC WORD PTR [SI]

transaction_full:
    POP SI
    POP CX
    POP BX
    POP AX
    RET
ADD_TRANSACTION ENDP

VIEW_HISTORY_PROC PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    LEA DX, history_header
    MOV AH, 09H
    INT 21H

    ; Get current user's transaction count
    MOV BX, current_user
    SHL BX, 1
    LEA SI, user_transaction_counts
    ADD SI, BX
    MOV CX, [SI]  ; CX = current user's transaction count
    CMP CX, 0
    JE no_trans

    MOV BX, 0
history_loop:
    CMP BX, CX
    JGE history_done

    ; Get transaction type for current user
    MOV AX, current_user
    MOV DX, 50
    MUL DX
    LEA SI, user_transaction_types
    ADD SI, AX
    ADD SI, BX
    MOV AL, [SI]

    CMP AL, 'D'
    JE show_deposit
    CMP AL, 'W'
    JE show_withdraw
    CMP AL, 'L'
    JE show_loan
    JMP after_label

show_deposit:
    LEA DX, deposit_label
    MOV AH, 09H
    INT 21H
    JMP after_label

show_withdraw:
    LEA DX, withdraw_label
    MOV AH, 09H
    INT 21H
    JMP after_label

show_loan:
    LEA DX, loan_history_label
    MOV AH, 09H
    INT 21H

after_label:
    PUSH BX
    ; Get transaction amount for current user
    MOV AX, current_user
    MOV DX, 100  ; 50 * 2 (words)
    MUL DX
    LEA SI, user_transaction_amounts
    ADD SI, AX
    SHL BX, 1
    ADD SI, BX
    MOV AX, [SI]
    CALL DISPLAY_NUMBER
    POP BX

    LEA DX, newline
    MOV AH, 09H
    INT 21H

    INC BX
    JMP history_loop

no_trans:
    LEA DX, no_transactions
    MOV AH, 09H
    INT 21H
    JMP history_exit

history_done:
    LEA DX, newline
    MOV AH, 09H
    INT 21H

history_exit:
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
VIEW_HISTORY_PROC ENDP

STRING_TO_NUMBER PROC
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI

    XOR DX, DX
    MOV BX, 10
    MOV CL, input_amount+1
    MOV CH, 0
    LEA SI, input_amount+2

stn_loop:
    JCXZ stn_done
    LODSB
    CMP AL, 13
    JE stn_done
    SUB AL, '0'
    CMP AL, 9
    JA stn_done
    MOV AH, 0
    MOV DI, AX

    MOV AX, DX
    MUL BX
    ADD AX, DI
    MOV DX, AX

    DEC CX
    JMP stn_loop

stn_done:
    MOV AX, DX

    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    RET
STRING_TO_NUMBER ENDP

DISPLAY_NUMBER PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV BX, 10
    MOV CX, 0

    CMP AX, 0
    JNE divide_loop
    MOV DL, '0'
    MOV AH, 02H
    INT 21H
    JMP display_done

divide_loop:
    CMP AX, 0
    JE display_digits
    MOV DX, 0
    DIV BX
    PUSH DX
    INC CX
    JMP divide_loop

display_digits:
    CMP CX, 0
    JE display_done
    POP DX
    ADD DL, '0'
    MOV AH, 02H
    INT 21H
    DEC CX
    JMP display_digits

display_done:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
DISPLAY_NUMBER ENDP

END MAIN






