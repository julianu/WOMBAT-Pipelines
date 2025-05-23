process RUN_SEARCHGUI {
  label 'process_high'

  conda params.enable_conda ? "bioconda::searchgui-4.2.9" : null

  container "${workflow.containerEngine == 'singularity' || workflow.containerEngine == 'apptainer'
    ? 'docker://veitveit/searchgui:4.2.9--hdfd78af_0'
    : 'quay.io/biocontainers/searchgui:4.2.9--hdfd78af_0'}"
  
  publishDir "${params.outdir}/searchgui", mode:'copy', pattern: '*.zip'
  
  input:
  path mgffile
  path paramfile
  path fasta_decoy
  
  output:
  tuple path("${mgffile.baseName}.zip"), path(mgffile), emit: searchfiles
  
  script:
  // TODO: fix engines
  // working: xtandem, msgf, ms-amanda, myrimatch, meta_morpheus
  // problems: comet, tide, andromeda
  def engine = [:]
  ["xtandem", "msgf", "ms-amanda", "tide", "comet", "myrimatch", "meta_morpheus", "andromeda"].each { se ->
    def t_engine = params.searchgui_engines.contains(se) ? 1 : 0
    engine.put(se, t_engine)
  }
  """
  # needed for Myrimatch, see https://github.com/compomics/searchgui/issues/245
        LANG=/usr/lib/locale/en_US
        export LC_ALL=C; unset LANGUAGE
  mkdir tmp
  mkdir log
  searchgui eu.isas.searchgui.cmd.PathSettingsCLI -temp_folder ./tmp -log ./log
  searchgui eu.isas.searchgui.cmd.SearchCLI -spectrum_files ./  -output_folder ./ -fasta_file "./${fasta_decoy}"  -id_params "./${paramfile}" -threads ${task.cpus} \\
      -xtandem ${engine["xtandem"]} -msgf ${engine["msgf"]} -comet ${engine["comet"]} -ms_amanda ${engine["ms-amanda"]} -myrimatch ${engine["myrimatch"]} \\
      -tide ${engine["tide"]} -meta_morpheus ${engine["meta_morpheus"]} -andromeda ${engine["andromeda"]}
  mv searchgui_out.zip ${mgffile.baseName}.zip
  """    
  
  }