/*
 *	MODULE:		iberror.h
 *	DESCRIPTION:	ISC error codes
 *
 */
/*
 * Copyright (C) 2001 Borland Software Corporation
 * All Rights Reserved.
 */



/***********************/
/*   ISC Error Codes   */
/***********************/

#define isc_arith_except                     335544321L
#define isc_bad_dbkey                        335544322L
#define isc_bad_db_format                    335544323L
#define isc_bad_db_handle                    335544324L
#define isc_bad_dpb_content                  335544325L
#define isc_bad_dpb_form                     335544326L
#define isc_bad_req_handle                   335544327L
#define isc_bad_segstr_handle                335544328L
#define isc_bad_segstr_id                    335544329L
#define isc_bad_tpb_content                  335544330L
#define isc_bad_tpb_form                     335544331L
#define isc_bad_trans_handle                 335544332L
#define isc_bug_check                        335544333L
#define isc_convert_error                    335544334L
#define isc_db_corrupt                       335544335L
#define isc_deadlock                         335544336L
#define isc_excess_trans                     335544337L
#define isc_from_no_match                    335544338L
#define isc_infinap                          335544339L
#define isc_infona                           335544340L
#define isc_infunk                           335544341L
#define isc_integ_fail                       335544342L
#define isc_invalid_blr                      335544343L
#define isc_io_error                         335544344L
#define isc_lock_conflict                    335544345L
#define isc_metadata_corrupt                 335544346L
#define isc_not_valid                        335544347L
#define isc_no_cur_rec                       335544348L
#define isc_no_dup                           335544349L
#define isc_no_finish                        335544350L
#define isc_no_meta_update                   335544351L
#define isc_no_priv                          335544352L
#define isc_no_recon                         335544353L
#define isc_no_record                        335544354L
#define isc_no_segstr_close                  335544355L
#define isc_obsolete_metadata                335544356L
#define isc_open_trans                       335544357L
#define isc_port_len                         335544358L
#define isc_read_only_field                  335544359L
#define isc_read_only_rel                    335544360L
#define isc_read_only_trans                  335544361L
#define isc_read_only_view                   335544362L
#define isc_req_no_trans                     335544363L
#define isc_req_sync                         335544364L
#define isc_req_wrong_db                     335544365L
#define isc_segment                          335544366L
#define isc_segstr_eof                       335544367L
#define isc_segstr_no_op                     335544368L
#define isc_segstr_no_read                   335544369L
#define isc_segstr_no_trans                  335544370L
#define isc_segstr_no_write                  335544371L
#define isc_segstr_wrong_db                  335544372L
#define isc_sys_request                      335544373L
#define isc_stream_eof                       335544374L
#define isc_unavailable                      335544375L
#define isc_unres_rel                        335544376L
#define isc_uns_ext                          335544377L
#define isc_wish_list                        335544378L
#define isc_wrong_ods                        335544379L
#define isc_wronumarg                        335544380L
#define isc_imp_exc                          335544381L
#define isc_random                           335544382L
#define isc_fatal_conflict                   335544383L
#define isc_badblk                           335544384L
#define isc_invpoolcl                        335544385L
#define isc_nopoolids                        335544386L
#define isc_relbadblk                        335544387L
#define isc_blktoobig                        335544388L
#define isc_bufexh                           335544389L
#define isc_syntaxerr                        335544390L
#define isc_bufinuse                         335544391L
#define isc_bdbincon                         335544392L
#define isc_reqinuse                         335544393L
#define isc_badodsver                        335544394L
#define isc_relnotdef                        335544395L
#define isc_fldnotdef                        335544396L
#define isc_dirtypage                        335544397L
#define isc_waifortra                        335544398L
#define isc_doubleloc                        335544399L
#define isc_nodnotfnd                        335544400L
#define isc_dupnodfnd                        335544401L
#define isc_locnotmar                        335544402L
#define isc_badpagtyp                        335544403L
#define isc_corrupt                          335544404L
#define isc_badpage                          335544405L
#define isc_badindex                         335544406L
#define isc_dbbnotzer                        335544407L
#define isc_tranotzer                        335544408L
#define isc_trareqmis                        335544409L
#define isc_badhndcnt                        335544410L
#define isc_wrotpbver                        335544411L
#define isc_wroblrver                        335544412L
#define isc_wrodpbver                        335544413L
#define isc_blobnotsup                       335544414L
#define isc_badrelation                      335544415L
#define isc_nodetach                         335544416L
#define isc_notremote                        335544417L
#define isc_trainlim                         335544418L
#define isc_notinlim                         335544419L
#define isc_traoutsta                        335544420L
#define isc_connect_reject                   335544421L
#define isc_dbfile                           335544422L
#define isc_orphan                           335544423L
#define isc_no_lock_mgr                      335544424L
#define isc_ctxinuse                         335544425L
#define isc_ctxnotdef                        335544426L
#define isc_datnotsup                        335544427L
#define isc_badmsgnum                        335544428L
#define isc_badparnum                        335544429L
#define isc_virmemexh                        335544430L
#define isc_blocking_signal                  335544431L
#define isc_lockmanerr                       335544432L
#define isc_journerr                         335544433L
#define isc_keytoobig                        335544434L
#define isc_nullsegkey                       335544435L
#define isc_sqlerr                           335544436L
#define isc_wrodynver                        335544437L
#define isc_funnotdef                        335544438L
#define isc_funmismat                        335544439L
#define isc_bad_msg_vec                      335544440L
#define isc_bad_detach                       335544441L
#define isc_noargacc_read                    335544442L
#define isc_noargacc_write                   335544443L
#define isc_read_only                        335544444L
#define isc_ext_err                          335544445L
#define isc_non_updatable                    335544446L
#define isc_no_rollback                      335544447L
#define isc_bad_sec_info                     335544448L
#define isc_invalid_sec_info                 335544449L
#define isc_misc_interpreted                 335544450L
#define isc_update_conflict                  335544451L
#define isc_unlicensed                       335544452L
#define isc_obj_in_use                       335544453L
#define isc_nofilter                         335544454L
#define isc_shadow_accessed                  335544455L
#define isc_invalid_sdl                      335544456L
#define isc_out_of_bounds                    335544457L
#define isc_invalid_dimension                335544458L
#define isc_rec_in_limbo                     335544459L
#define isc_shadow_missing                   335544460L
#define isc_cant_validate                    335544461L
#define isc_cant_start_journal               335544462L
#define isc_gennotdef                        335544463L
#define isc_cant_start_logging               335544464L
#define isc_bad_segstr_type                  335544465L
#define isc_foreign_key                      335544466L
#define isc_high_minor                       335544467L
#define isc_tra_state                        335544468L
#define isc_trans_invalid                    335544469L
#define isc_buf_invalid                      335544470L
#define isc_indexnotdefined                  335544471L
#define isc_login                            335544472L
#define isc_invalid_bookmark                 335544473L
#define isc_bad_lock_level                   335544474L
#define isc_relation_lock                    335544475L
#define isc_record_lock                      335544476L
#define isc_max_idx                          335544477L
#define isc_jrn_enable                       335544478L
#define isc_old_failure                      335544479L
#define isc_old_in_progress                  335544480L
#define isc_old_no_space                     335544481L
#define isc_no_wal_no_jrn                    335544482L
#define isc_num_old_files                    335544483L
#define isc_wal_file_open                    335544484L
#define isc_bad_stmt_handle                  335544485L
#define isc_wal_failure                      335544486L
#define isc_walw_err                         335544487L
#define isc_logh_small                       335544488L
#define isc_logh_inv_version                 335544489L
#define isc_logh_open_flag                   335544490L
#define isc_logh_open_flag2                  335544491L
#define isc_logh_diff_dbname                 335544492L
#define isc_logf_unexpected_eof              335544493L
#define isc_logr_incomplete                  335544494L
#define isc_logr_header_small                335544495L
#define isc_logb_small                       335544496L
#define isc_wal_illegal_attach               335544497L
#define isc_wal_invalid_wpb                  335544498L
#define isc_wal_err_rollover                 335544499L
#define isc_no_wal                           335544500L
#define isc_drop_wal                         335544501L
#define isc_stream_not_defined               335544502L
#define isc_wal_subsys_error                 335544503L
#define isc_wal_subsys_corrupt               335544504L
#define isc_no_archive                       335544505L
#define isc_shutinprog                       335544506L
#define isc_range_in_use                     335544507L
#define isc_range_not_found                  335544508L
#define isc_charset_not_found                335544509L
#define isc_lock_timeout                     335544510L
#define isc_prcnotdef                        335544511L
#define isc_prcmismat                        335544512L
#define isc_wal_bugcheck                     335544513L
#define isc_wal_cant_expand                  335544514L
#define isc_codnotdef                        335544515L
#define isc_xcpnotdef                        335544516L
#define isc_except                           335544517L
#define isc_cache_restart                    335544518L
#define isc_bad_lock_handle                  335544519L
#define isc_jrn_present                      335544520L
#define isc_wal_err_rollover2                335544521L
#define isc_wal_err_logwrite                 335544522L
#define isc_wal_err_jrn_comm                 335544523L
#define isc_wal_err_expansion                335544524L
#define isc_wal_err_setup                    335544525L
#define isc_wal_err_ww_sync                  335544526L
#define isc_wal_err_ww_start                 335544527L
#define isc_shutdown                         335544528L
#define isc_existing_priv_mod                335544529L
#define isc_primary_key_ref                  335544530L
#define isc_primary_key_notnull              335544531L
#define isc_ref_cnstrnt_notfound             335544532L
#define isc_foreign_key_notfound             335544533L
#define isc_ref_cnstrnt_update               335544534L
#define isc_check_cnstrnt_update             335544535L
#define isc_check_cnstrnt_del                335544536L
#define isc_integ_index_seg_del              335544537L
#define isc_integ_index_seg_mod              335544538L
#define isc_integ_index_del                  335544539L
#define isc_integ_index_mod                  335544540L
#define isc_check_trig_del                   335544541L
#define isc_check_trig_update                335544542L
#define isc_cnstrnt_fld_del                  335544543L
#define isc_cnstrnt_fld_rename               335544544L
#define isc_rel_cnstrnt_update               335544545L
#define isc_constaint_on_view                335544546L
#define isc_invld_cnstrnt_type               335544547L
#define isc_primary_key_exists               335544548L
#define isc_systrig_update                   335544549L
#define isc_not_rel_owner                    335544550L
#define isc_grant_obj_notfound               335544551L
#define isc_grant_fld_notfound               335544552L
#define isc_grant_nopriv                     335544553L
#define isc_nonsql_security_rel              335544554L
#define isc_nonsql_security_fld              335544555L
#define isc_wal_cache_err                    335544556L
#define isc_shutfail                         335544557L
#define isc_check_constraint                 335544558L
#define isc_bad_svc_handle                   335544559L
#define isc_shutwarn                         335544560L
#define isc_wrospbver                        335544561L
#define isc_bad_spb_form                     335544562L
#define isc_svcnotdef                        335544563L
#define isc_no_jrn                           335544564L
#define isc_transliteration_failed           335544565L
#define isc_start_cm_for_wal                 335544566L
#define isc_wal_ovflow_log_required          335544567L
#define isc_text_subtype                     335544568L
#define isc_dsql_error                       335544569L
#define isc_dsql_command_err                 335544570L
#define isc_dsql_constant_err                335544571L
#define isc_dsql_cursor_err                  335544572L
#define isc_dsql_datatype_err                335544573L
#define isc_dsql_decl_err                    335544574L
#define isc_dsql_cursor_update_err           335544575L
#define isc_dsql_cursor_open_err             335544576L
#define isc_dsql_cursor_close_err            335544577L
#define isc_dsql_field_err                   335544578L
#define isc_dsql_internal_err                335544579L
#define isc_dsql_relation_err                335544580L
#define isc_dsql_procedure_err               335544581L
#define isc_dsql_request_err                 335544582L
#define isc_dsql_sqlda_err                   335544583L
#define isc_dsql_var_count_err               335544584L
#define isc_dsql_stmt_handle                 335544585L
#define isc_dsql_function_err                335544586L
#define isc_dsql_blob_err                    335544587L
#define isc_collation_not_found              335544588L
#define isc_collation_not_for_charset        335544589L
#define isc_dsql_dup_option                  335544590L
#define isc_dsql_tran_err                    335544591L
#define isc_dsql_invalid_array               335544592L
#define isc_dsql_max_arr_dim_exceeded        335544593L
#define isc_dsql_arr_range_error             335544594L
#define isc_dsql_trigger_err                 335544595L
#define isc_dsql_subselect_err               335544596L
#define isc_dsql_crdb_prepare_err            335544597L
#define isc_specify_field_err                335544598L
#define isc_num_field_err                    335544599L
#define isc_col_name_err                     335544600L
#define isc_where_err                        335544601L
#define isc_table_view_err                   335544602L
#define isc_distinct_err                     335544603L
#define isc_key_field_count_err              335544604L
#define isc_subquery_err                     335544605L
#define isc_expression_eval_err              335544606L
#define isc_node_err                         335544607L
#define isc_command_end_err                  335544608L
#define isc_index_name                       335544609L
#define isc_exception_name                   335544610L
#define isc_field_name                       335544611L
#define isc_token_err                        335544612L
#define isc_union_err                        335544613L
#define isc_dsql_construct_err               335544614L
#define isc_field_aggregate_err              335544615L
#define isc_field_ref_err                    335544616L
#define isc_order_by_err                     335544617L
#define isc_return_mode_err                  335544618L
#define isc_extern_func_err                  335544619L
#define isc_alias_conflict_err               335544620L
#define isc_procedure_conflict_error         335544621L
#define isc_relation_conflict_err            335544622L
#define isc_dsql_domain_err                  335544623L
#define isc_idx_seg_err                      335544624L
#define isc_node_name_err                    335544625L
#define isc_table_name                       335544626L
#define isc_proc_name                        335544627L
#define isc_idx_create_err                   335544628L
#define isc_wal_shadow_err                   335544629L
#define isc_dependency                       335544630L
#define isc_idx_key_err                      335544631L
#define isc_dsql_file_length_err             335544632L
#define isc_dsql_shadow_number_err           335544633L
#define isc_dsql_token_unk_err               335544634L
#define isc_dsql_no_relation_alias           335544635L
#define isc_indexname                        335544636L
#define isc_no_stream_plan                   335544637L
#define isc_stream_twice                     335544638L
#define isc_stream_not_found                 335544639L
#define isc_collation_requires_text          335544640L
#define isc_dsql_domain_not_found            335544641L
#define isc_index_unused                     335544642L
#define isc_dsql_self_join                   335544643L
#define isc_stream_bof                       335544644L
#define isc_stream_crack                     335544645L
#define isc_db_or_file_exists                335544646L
#define isc_invalid_operator                 335544647L
#define isc_conn_lost                        335544648L
#define isc_bad_checksum                     335544649L
#define isc_page_type_err                    335544650L
#define isc_ext_readonly_err                 335544651L
#define isc_sing_select_err                  335544652L
#define isc_psw_attach                       335544653L
#define isc_psw_start_trans                  335544654L
#define isc_invalid_direction                335544655L
#define isc_dsql_var_conflict                335544656L
#define isc_dsql_no_blob_array               335544657L
#define isc_dsql_base_table                  335544658L
#define isc_duplicate_base_table             335544659L
#define isc_view_alias                       335544660L
#define isc_index_root_page_full             335544661L
#define isc_dsql_blob_type_unknown           335544662L
#define isc_req_max_clones_exceeded          335544663L
#define isc_dsql_duplicate_spec              335544664L
#define isc_unique_key_violation             335544665L
#define isc_srvr_version_too_old             335544666L
#define isc_drdb_completed_with_errs         335544667L
#define isc_dsql_procedure_use_err           335544668L
#define isc_dsql_count_mismatch              335544669L
#define isc_blob_idx_err                     335544670L
#define isc_array_idx_err                    335544671L
#define isc_key_field_err                    335544672L
#define isc_no_delete                        335544673L
#define isc_del_last_field                   335544674L
#define isc_sort_err                         335544675L
#define isc_sort_mem_err                     335544676L
#define isc_version_err                      335544677L
#define isc_inval_key_posn                   335544678L
#define isc_no_segments_err                  335544679L
#define isc_crrp_data_err                    335544680L
#define isc_rec_size_err                     335544681L
#define isc_dsql_field_ref                   335544682L
#define isc_req_depth_exceeded               335544683L
#define isc_no_field_access                  335544684L
#define isc_no_dbkey                         335544685L
#define isc_jrn_format_err                   335544686L
#define isc_jrn_file_full                    335544687L
#define isc_dsql_open_cursor_request         335544688L
#define isc_ib_error                         335544689L
#define isc_cache_redef                      335544690L
#define isc_cache_too_small                  335544691L
#define isc_log_redef                        335544692L
#define isc_log_too_small                    335544693L
#define isc_partition_too_small              335544694L
#define isc_partition_not_supp               335544695L
#define isc_log_length_spec                  335544696L
#define isc_precision_err                    335544697L
#define isc_scale_nogt                       335544698L
#define isc_expec_short                      335544699L
#define isc_expec_long                       335544700L
#define isc_expec_ushort                     335544701L
#define isc_like_escape_invalid              335544702L
#define isc_svcnoexe                         335544703L
#define isc_net_lookup_err                   335544704L
#define isc_service_unknown                  335544705L
#define isc_host_unknown                     335544706L
#define isc_grant_nopriv_on_base             335544707L
#define isc_dyn_fld_ambiguous                335544708L
#define isc_dsql_agg_ref_err                 335544709L
#define isc_complex_view                     335544710L
#define isc_unprepared_stmt                  335544711L
#define isc_expec_positive                   335544712L
#define isc_dsql_sqlda_value_err             335544713L
#define isc_invalid_array_id                 335544714L
#define isc_extfile_uns_op                   335544715L
#define isc_svc_in_use                       335544716L
#define isc_err_stack_limit                  335544717L
#define isc_invalid_key                      335544718L
#define isc_net_init_error                   335544719L
#define isc_loadlib_failure                  335544720L
#define isc_network_error                    335544721L
#define isc_net_connect_err                  335544722L
#define isc_net_connect_listen_err           335544723L
#define isc_net_event_connect_err            335544724L
#define isc_net_event_listen_err             335544725L
#define isc_net_read_err                     335544726L
#define isc_net_write_err                    335544727L
#define isc_integ_index_deactivate           335544728L
#define isc_integ_deactivate_primary         335544729L
#define isc_cse_not_supported                335544730L
#define isc_tra_must_sweep                   335544731L
#define isc_unsupported_network_drive        335544732L
#define isc_io_create_err                    335544733L
#define isc_io_open_err                      335544734L
#define isc_io_close_err                     335544735L
#define isc_io_read_err                      335544736L
#define isc_io_write_err                     335544737L
#define isc_io_delete_err                    335544738L
#define isc_io_access_err                    335544739L
#define isc_udf_exception                    335544740L
#define isc_lost_db_connection               335544741L
#define isc_no_write_user_priv               335544742L
#define isc_token_too_long                   335544743L
#define isc_max_att_exceeded                 335544744L
#define isc_login_same_as_role_name          335544745L
#define isc_reftable_requires_pk             335544746L
#define isc_usrname_too_long                 335544747L
#define isc_password_too_long                335544748L
#define isc_usrname_required                 335544749L
#define isc_password_required                335544750L
#define isc_bad_protocol                     335544751L
#define isc_dup_usrname_found                335544752L
#define isc_usrname_not_found                335544753L
#define isc_error_adding_sec_record          335544754L
#define isc_error_modifying_sec_record       335544755L
#define isc_error_deleting_sec_record        335544756L
#define isc_error_updating_sec_db            335544757L
#define isc_sort_rec_size_err                335544758L
#define isc_bad_default_value                335544759L
#define isc_invalid_clause                   335544760L
#define isc_too_many_handles                 335544761L
#define isc_optimizer_blk_exc                335544762L
#define isc_invalid_string_constant          335544763L
#define isc_transitional_date                335544764L
#define isc_read_only_database               335544765L
#define isc_must_be_dialect_2_and_up         335544766L
#define isc_blob_filter_exception            335544767L
#define isc_exception_access_violation       335544768L
#define isc_exception_datatype_missalignment 335544769L
#define isc_exception_array_bounds_exceeded  335544770L
#define isc_exception_float_denormal_operand 335544771L
#define isc_exception_float_divide_by_zero   335544772L
#define isc_exception_float_inexact_result   335544773L
#define isc_exception_float_invalid_operand  335544774L
#define isc_exception_float_overflow         335544775L
#define isc_exception_float_stack_check      335544776L
#define isc_exception_float_underflow        335544777L
#define isc_exception_integer_divide_by_zero 335544778L
#define isc_exception_integer_overflow       335544779L
#define isc_exception_unknown                335544780L
#define isc_exception_stack_overflow         335544781L
#define isc_exception_sigsegv                335544782L
#define isc_exception_sigill                 335544783L
#define isc_exception_sigbus                 335544784L
#define isc_exception_sigfpe                 335544785L
#define isc_ext_file_delete                  335544786L
#define isc_ext_file_modify                  335544787L
#define isc_adm_task_denied                  335544788L
#define isc_extract_input_mismatch           335544789L
#define isc_insufficient_svc_privileges      335544790L
#define isc_file_in_use                      335544791L
#define isc_service_att_err                  335544792L
#define isc_ddl_not_allowed_by_db_sql_dial   335544793L
#define isc_cancelled                        335544794L
#define isc_unexp_spb_form                   335544795L
#define isc_sql_dialect_datatype_unsupport   335544796L
#define isc_svcnouser                        335544797L
#define isc_depend_on_uncommitted_rel        335544798L
#define isc_svc_name_missing                 335544799L
#define isc_too_many_contexts                335544800L
#define isc_datype_notsup                    335544801L
#define isc_dialect_reset_warning            335544802L
#define isc_dialect_not_changed              335544803L
#define isc_database_create_failed           335544804L
#define isc_inv_dialect_specified            335544805L
#define isc_valid_db_dialects                335544806L
#define isc_sqlwarn                          335544807L
#define isc_dtype_renamed                    335544808L
#define isc_extern_func_dir_error            335544809L
#define isc_date_range_exceeded              335544810L
#define isc_inv_client_dialect_specified     335544811L
#define isc_valid_client_dialects            335544812L
#define isc_optimizer_between_err            335544813L
#define isc_service_not_supported            335544814L
#define isc_gfix_db_name                     335740929L
#define isc_gfix_invalid_sw                  335740930L
#define isc_gfix_incmp_sw                    335740932L
#define isc_gfix_replay_req                  335740933L
#define isc_gfix_pgbuf_req                   335740934L
#define isc_gfix_val_req                     335740935L
#define isc_gfix_pval_req                    335740936L
#define isc_gfix_trn_req                     335740937L
#define isc_gfix_full_req                    335740940L
#define isc_gfix_usrname_req                 335740941L
#define isc_gfix_pass_req                    335740942L
#define isc_gfix_subs_name                   335740943L
#define isc_gfix_wal_req                     335740944L
#define isc_gfix_sec_req                     335740945L
#define isc_gfix_nval_req                    335740946L
#define isc_gfix_type_shut                   335740947L
#define isc_gfix_retry                       335740948L
#define isc_gfix_retry_db                    335740951L
#define isc_gfix_exceed_max                  335740991L
#define isc_gfix_corrupt_pool                335740992L
#define isc_gfix_mem_exhausted               335740993L
#define isc_gfix_bad_pool                    335740994L
#define isc_gfix_trn_not_valid               335740995L
#define isc_gfix_unexp_eoi                   335741012L
#define isc_gfix_recon_fail                  335741018L
#define isc_gfix_trn_unknown                 335741036L
#define isc_gfix_mode_req                    335741038L
#define isc_gfix_opt_SQL_dialect             335741039L
#define isc_dsql_dbkey_from_non_table        336003074L
#define isc_dsql_transitional_numeric        336003075L
#define isc_dsql_dialect_warning_expr        336003076L
#define isc_sql_db_dialect_dtype_unsupport   336003077L
#define isc_isc_sql_dialect_conflict_num     336003079L
#define isc_dsql_warning_number_ambiguous    336003080L
#define isc_dsql_warning_number_ambiguous1   336003081L
#define isc_dsql_warn_precision_ambiguous    336003082L
#define isc_dsql_warn_precision_ambiguous1   336003083L
#define isc_dsql_warn_precision_ambiguous2   336003084L
#define isc_dsql_rows_ties_err               336003085L
#define isc_dyn_role_does_not_exist          336068796L
#define isc_dyn_no_grant_admin_opt           336068797L
#define isc_dyn_user_not_role_member         336068798L
#define isc_dyn_delete_role_failed           336068799L
#define isc_dyn_grant_role_to_user           336068800L
#define isc_dyn_inv_sql_role_name            336068801L
#define isc_dyn_dup_sql_role                 336068802L
#define isc_dyn_kywd_spec_for_role           336068803L
#define isc_dyn_roles_not_supported          336068804L
#define isc_dyn_domain_name_exists           336068812L
#define isc_dyn_field_name_exists            336068813L
#define isc_dyn_dependency_exists            336068814L
#define isc_dyn_dtype_invalid                336068815L
#define isc_dyn_char_fld_too_small           336068816L
#define isc_dyn_invalid_dtype_conversion     336068817L
#define isc_dyn_dtype_conv_invalid           336068818L
#define isc_gbak_unknown_switch              336330753L
#define isc_gbak_page_size_missing           336330754L
#define isc_gbak_page_size_toobig            336330755L
#define isc_gbak_redir_ouput_missing         336330756L
#define isc_gbak_switches_conflict           336330757L
#define isc_gbak_unknown_device              336330758L
#define isc_gbak_no_protection               336330759L
#define isc_gbak_page_size_not_allowed       336330760L
#define isc_gbak_multi_source_dest           336330761L
#define isc_gbak_filename_missing            336330762L
#define isc_gbak_dup_inout_names             336330763L
#define isc_gbak_inv_page_size               336330764L
#define isc_gbak_db_specified                336330765L
#define isc_gbak_db_exists                   336330766L
#define isc_gbak_unk_device                  336330767L
#define isc_gbak_blob_info_failed            336330772L
#define isc_gbak_unk_blob_item               336330773L
#define isc_gbak_get_seg_failed              336330774L
#define isc_gbak_close_blob_failed           336330775L
#define isc_gbak_open_blob_failed            336330776L
#define isc_gbak_put_blr_gen_id_failed       336330777L
#define isc_gbak_unk_type                    336330778L
#define isc_gbak_comp_req_failed             336330779L
#define isc_gbak_start_req_failed            336330780L
#define isc_gbak_rec_failed                  336330781L
#define isc_gbak_rel_req_failed              336330782L
#define isc_gbak_db_info_failed              336330783L
#define isc_gbak_no_db_desc                  336330784L
#define isc_gbak_db_create_failed            336330785L
#define isc_gbak_decomp_len_error            336330786L
#define isc_gbak_tbl_missing                 336330787L
#define isc_gbak_blob_col_missing            336330788L
#define isc_gbak_create_blob_failed          336330789L
#define isc_gbak_put_seg_failed              336330790L
#define isc_gbak_rec_len_exp                 336330791L
#define isc_gbak_inv_rec_len                 336330792L
#define isc_gbak_exp_data_type               336330793L
#define isc_gbak_gen_id_failed               336330794L
#define isc_gbak_unk_rec_type                336330795L
#define isc_gbak_inv_bkup_ver                336330796L
#define isc_gbak_missing_bkup_desc           336330797L
#define isc_gbak_string_trunc                336330798L
#define isc_gbak_cant_rest_record            336330799L
#define isc_gbak_send_failed                 336330800L
#define isc_gbak_no_tbl_name                 336330801L
#define isc_gbak_unexp_eof                   336330802L
#define isc_gbak_db_format_too_old           336330803L
#define isc_gbak_inv_array_dim               336330804L
#define isc_gbak_xdr_len_expected            336330807L
#define isc_gbak_open_bkup_error             336330817L
#define isc_gbak_open_error                  336330818L
#define isc_gbak_missing_block_fac           336330934L
#define isc_gbak_inv_block_fac               336330935L
#define isc_gbak_block_fac_specified         336330936L
#define isc_gbak_missing_username            336330940L
#define isc_gbak_missing_password            336330941L
#define isc_gbak_missing_skipped_bytes       336330952L
#define isc_gbak_inv_skipped_bytes           336330953L
#define isc_gbak_err_restore_charset         336330965L
#define isc_gbak_err_restore_collation       336330967L
#define isc_gbak_read_error                  336330972L
#define isc_gbak_write_error                 336330973L
#define isc_gbak_db_in_use                   336330985L
#define isc_gbak_sysmemex                    336330990L
#define isc_gbak_restore_role_failed         336331002L
#define isc_gbak_role_op_missing             336331005L
#define isc_gbak_page_buffers_missing        336331010L
#define isc_gbak_page_buffers_wrong_param    336331011L
#define isc_gbak_page_buffers_restore        336331012L
#define isc_gbak_inv_size                    336331014L
#define isc_gbak_file_outof_sequence         336331015L
#define isc_gbak_join_file_missing           336331016L
#define isc_gbak_stdin_not_supptd            336331017L
#define isc_gbak_stdout_not_supptd           336331018L
#define isc_gbak_bkup_corrupt                336331019L
#define isc_gbak_unk_db_file_spec            336331020L
#define isc_gbak_hdr_write_failed            336331021L
#define isc_gbak_disk_space_ex               336331022L
#define isc_gbak_size_lt_min                 336331023L
#define isc_gbak_svc_name_missing            336331025L
#define isc_gbak_not_ownr                    336331026L
#define isc_gbak_mode_req                    336331031L
#define isc_gsec_cant_open_db                336723983L
#define isc_gsec_switches_error              336723984L
#define isc_gsec_no_op_spec                  336723985L
#define isc_gsec_no_usr_name                 336723986L
#define isc_gsec_err_add                     336723987L
#define isc_gsec_err_modify                  336723988L
#define isc_gsec_err_find_mod                336723989L
#define isc_gsec_err_rec_not_found           336723990L
#define isc_gsec_err_delete                  336723991L
#define isc_gsec_err_find_del                336723992L
#define isc_gsec_err_find_disp               336723996L
#define isc_gsec_inv_param                   336723997L
#define isc_gsec_op_specified                336723998L
#define isc_gsec_pw_specified                336723999L
#define isc_gsec_uid_specified               336724000L
#define isc_gsec_gid_specified               336724001L
#define isc_gsec_proj_specified              336724002L
#define isc_gsec_org_specified               336724003L
#define isc_gsec_fname_specified             336724004L
#define isc_gsec_mname_specified             336724005L
#define isc_gsec_lname_specified             336724006L
#define isc_gsec_inv_switch                  336724008L
#define isc_gsec_amb_switch                  336724009L
#define isc_gsec_no_op_specified             336724010L
#define isc_gsec_params_not_allowed          336724011L
#define isc_gsec_incompat_switch             336724012L
#define isc_gsec_inv_username                336724044L
#define isc_gsec_inv_pw_length               336724045L
#define isc_gsec_db_specified                336724046L
#define isc_gsec_db_admin_specified          336724047L
#define isc_gsec_db_admin_pw_specified       336724048L
#define isc_gsec_sql_role_specified          336724049L
#define isc_license_no_file                  336789504L
#define isc_license_op_specified             336789523L
#define isc_license_op_missing               336789524L
#define isc_license_inv_switch               336789525L
#define isc_license_inv_switch_combo         336789526L
#define isc_license_inv_op_combo             336789527L
#define isc_license_amb_switch               336789528L
#define isc_license_inv_parameter            336789529L
#define isc_license_param_specified          336789530L
#define isc_license_param_req                336789531L
#define isc_license_syntx_error              336789532L
#define isc_license_dup_id                   336789534L
#define isc_license_inv_id_key               336789535L
#define isc_license_err_remove               336789536L
#define isc_license_err_update               336789537L
#define isc_license_err_convert              336789538L
#define isc_license_err_unk                  336789539L
#define isc_license_svc_err_add              336789540L
#define isc_license_svc_err_remove           336789541L
#define isc_license_eval_exists              336789563L
#define isc_gstat_unknown_switch             336920577L
#define isc_gstat_retry                      336920578L
#define isc_gstat_wrong_ods                  336920579L
#define isc_gstat_unexpected_eof             336920580L
#define isc_gstat_open_err                   336920605L
#define isc_gstat_read_err                   336920606L
#define isc_gstat_sysmemex                   336920607L
#define isc_err_max                          690

