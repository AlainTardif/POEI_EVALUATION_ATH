REPORT z_poec_integ_ath.

DATA: go_poec TYPE REF TO zcl_poec_ath.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_test TYPE abap_bool AS CHECKBOX DEFAULT abap_true.
SELECTION-SCREEN END OF BLOCK b01.

START-OF-SELECTION.
  CREATE OBJECT go_poec.
  go_poec->upload_and_process( iv_test_mode = p_test ).
  go_poec->display_report( ).