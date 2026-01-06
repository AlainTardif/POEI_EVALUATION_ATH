REPORT z_poec_integ_ath.

DATA: go_poec TYPE REF TO zcl_poec_ath.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_file TYPE string LOWER CASE.
  PARAMETERS: p_test AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  DATA: lt_files TYPE filetable,
        lv_rc    TYPE i.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title      = 'Sélectionner le fichier'
      default_extension = 'TXT'
      file_filter       = 'Fichiers texte (*.txt)|*.txt'
    CHANGING
      file_table        = lt_files
      rc                = lv_rc.

  IF lv_rc > 0.
    READ TABLE lt_files INDEX 1 INTO p_file.
  ENDIF.

START-OF-SELECTION.
  CREATE OBJECT go_poec.
  go_poec->upload_and_process( iv_test_mode = p_test ).
  go_poec->display_report( ).