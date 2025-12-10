#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { THERMORAWFILEPARSER } from '../../../../modules/bigbio/thermorawfileparser/main.nf'

workflow test_thermorawfileparser {
    // Test with UPS1_50amol_R3.raw from PRIDE archive
    input = [
        [ id:'test', mzml_id:'test_sample' ], // meta map
        file('http://ftp.ebi.ac.uk/pride-archive/2015/12/PXD001819/UPS1_50amol_R3.raw', checkIfExists: false)
    ]

    THERMORAWFILEPARSER ( input )
}

