REPORT z_poec_ath.

DATA: go_poec TYPE REF TO zcl_poec_ath.

DATA: gv_ebeln TYPE ebeln,
      gv_matnr TYPE matnr.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_ebeln FOR gv_ebeln NO-EXTENSION.
  SELECT-OPTIONS: s_matnr FOR gv_matnr NO-EXTENSION.
SELECTION-SCREEN END OF BLOCK b01.

START-OF-SELECTION.
  DATA: lv_ebeln TYPE ebeln,
        lv_matnr TYPE matnr.

  READ TABLE s_ebeln INDEX 1 INTO DATA(ls_ebeln).
  IF sy-subrc = 0.
    lv_ebeln = ls_ebeln-low.
  ENDIF.

  READ TABLE s_matnr INDEX 1 INTO DATA(ls_matnr).
  IF sy-subrc = 0.
    lv_matnr = ls_matnr-low.
  ENDIF.

  CREATE OBJECT go_poec
    EXPORTING
      iv_ebeln = lv_ebeln
      iv_matnr = lv_matnr.

  go_poec->get_data( ).
  CALL SCREEN 100.

MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_100'.
  SET TITLEBAR 'TITLE_100'.
  go_poec->display_alv( ).
ENDMODULE.

MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.