process CREATE_DECOY_DATABASE {
  label 'process_low'

  conda (params.enable_conda ? "bioconda::searchgui-4.0.41" : null)

  container "${workflow.containerEngine == 'singularity' || workflow.containerEngine == 'apptainer'
        ? 'docker://veitveit/searchgui:4.2.9--hdfd78af_0'
        : 'quay.io/biocontainers/searchgui:4.2.9--hdfd78af_0'}"
  
  publishDir "${params.outdir}/fasta_database", mode:'copy'

  input:
  path fasta
  val parameters

  output:
  path "*.fasta" , emit: fasta_with_decoy

  script:
  if (parameters.add_decoys) {
    """
    searchgui eu.isas.searchgui.cmd.FastaCLI -in ${fasta} -decoy
    """ 
  } else {
    """
    echo "No decoy database created, just copying it over"
    mv ${fasta} ${fasta.baseName}_wombat.fasta
    """
  }
}