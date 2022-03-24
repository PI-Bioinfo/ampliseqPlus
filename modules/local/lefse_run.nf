process LEFSE_RUN {
    label 'process_low'

    conda (params.enable_conda ? { exit 1 "LEFSE has no conda package" } : null)
    container "quay.io/biocontainers/lefse:1.1.2--pyhdfd78af_0"

    input:
    path(tsv)

    output:
    path("*.pdf")  , emit: pdf

    script:
    """
    lefse_format_input.py ${tsv} lefse_ready_table.in -c 1 -u 2 -o 1000000

    lefse_run.py lefse_ready_table.in lefse_ready_table.res

    lefse_plot_res.py lefse_ready_table.res lefse_res_bar.pdf --format pdf --dpi 300

    lefse_plot_cladogram.py lefse_ready_table.res lefse_res_clado.pdf --format pdf --dpi 300

    """
}
