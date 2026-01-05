REPORT z_poec_ath.

TABLES: zekko_ath.

DATA: go_poec TYPE REF TO zcl_poec_ath.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_ebeln FOR zekko_ath-ebeln NO INTERVALS.
  PARAMETERS: p_matnr TYPE matnr.
SELECTION-SCREEN END OF BLOCK b01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_ebeln-low.
  DATA: lt_ebeln TYPE TABLE OF zekko_ath,
        lt_ret   TYPE TABLE OF ddshretval.

  SELECT ebeln FROM zekko_ath INTO TABLE @lt_ebeln.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield    = 'EBELN'
      dynpprog    = sy-repid
      dynpnr      = sy-dynnr
      dynprofield = 'S_EBELN-LOW'
      value_org   = 'S'
    TABLES
      value_tab   = lt_ebeln
      return_tab  = lt_ret.

AT SELECTION-SCREEN.
  DATA: lv_ebeln TYPE ebeln.

  READ TABLE s_ebeln INDEX 1 INTO DATA(ls_ebeln).
  IF sy-subrc = 0.
    lv_ebeln = ls_ebeln-low.
  ENDIF.

  CREATE OBJECT go_poec
    EXPORTING
      iv_ebeln = lv_ebeln
      iv_matnr = p_matnr.

  go_poec->validate_selection( ).

START-OF-SELECTION.
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