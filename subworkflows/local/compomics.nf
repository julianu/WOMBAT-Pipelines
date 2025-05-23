//
// Run Compomics based workflow and normalyzer
//

include { PREPARE_SEARCHGUI }     from '../../modules/local/searchgui/prepare_searchgui/main'
include { RUN_SEARCHGUI }         from '../../modules/local/searchgui/run_searchgui/main'
include { RUN_PEPTIDESHAKER }     from '../../modules/local/peptideshaker/run_peptideshaker/main'
include { PEPTIDESHAKER_REPORT }  from '../../modules/local/peptideshaker/peptideshaker_report/main'
include { CONVERT_PROFORMA }      from '../../modules/local/peptideshaker/convert_proforma/main'
include { FLASHLFQ }              from '../../modules/local/flashlfq/main'
include { MSQROB }                from '../../modules/local/msqrob/main'
 
workflow COMPOMICS {
    take:
    fasta // fasta file
    mzmls // converted mzML files
    parameters // map of parameters 
    exp_design // experimental design file
    ptm_mapping // map to convert from unimod to searchgui
    raws // raw files (for MSqRob)

    main:
    PREPARE_SEARCHGUI ( parameters, ptm_mapping.collect() )
    // RUN_SEARCHGUI ( mzmls, PREPARE_SEARCHGUI.out,  search_fasta )
    // RUN_PEPTIDESHAKER ( RUN_SEARCHGUI.out, search_fasta )
    // PEPTIDESHAKER_REPORT ( RUN_PEPTIDESHAKER.out )
    // CONVERT_PROFORMA ( PEPTIDESHAKER_REPORT.out.peptideshaker_peptide_file, PEPTIDESHAKER_REPORT.out.peptideshaker_protein_file, 
    //                    PEPTIDESHAKER_REPORT.out.peptideshaker_tsv_file_filtered )
    // FLASHLFQ ( CONVERT_PROFORMA.out.peptideshaker_proforma_filtered.collect(), mzmls.collect(), parameters, exp_design )
    // MSQROB ( exp_design, raws.collect(), FLASHLFQ.out.flashlfq_peptides, FLASHLFQ.out.flashlfq_proteins, 
    //          FLASHLFQ.out.flashlfq_ions, CONVERT_PROFORMA.out.peptideshaker_proforma_peptides.collect(), 
    //          CONVERT_PROFORMA.out.peptideshaker_proforma_proteins.collect() , parameters)

    // emit:
    // exp_design = MSQROB.out.exp_design_final
    // stdprotquant = MSQROB.out.stdprotquant
    // stdpepquant = MSQROB.out.stdpepquant
    // stdionquant = MSQROB.out.stdionquant
    // msqrob_prot_out = MSQROB.out.msqrob_prot_out
}
