def fastq_input(r1):
    if config.get("read_type")=="se":
        return r1
    else:
        r2=r1.replace("-R1-", "-R2-")
        reads=[r1,r2]
        return " ".join(reads)

rule featureCountsExon_run:
    input:
        bam="star/{sample}/{sample}.Aligned.sortedByCoord.out.bam"
    output:
        "featurecounts/{sample}/count/{sample}_featurecountsexon.cnt"
    conda:
        "../envs/featureCounts.yaml"
    params:
        gff=resolve_single_filepath(*references_abs_path(ref='references'),
                                    config.get("genes_gff")),
        gtf_feature_type=config.get("rules").get("featureCounts_run").get("gtf_feature_type1"),
    threads: pipeline_cpu_count()
    shell:
        "featureCounts -T {threads} -s 1 "
        "-f -t {params.gtf_feature_type} -a "
        "{params.gff} "
        "-o {output} "
        "{input.bam}"

rule featureCountsLnc_run:
    input:
        bam="star/{sample}/{sample}.Aligned.sortedByCoord.out.bam"
    output:
        "featurecounts/{sample}/count/{sample}_featurecountslnc.cnt"
    conda:
        "../envs/featureCounts.yaml"
    params:
        gff=resolve_single_filepath(*references_abs_path(ref='references'),
                                    config.get("genes_gff")),
        gtf_feature_type=config.get("rules").get("featureCounts_run").get("gtf_feature_type2"),
    threads: pipeline_cpu_count()
    shell:
        "featureCounts -T {threads} -s 1 "
        "-f -t {params.gtf_feature_type} -a "
        "{params.gff} "
        "-o {output} "
        "{input.bam}"

rule merge:
    input:
        "featurecounts/{sample}/count/{sample}_featurecountsexon.cnt",
        "featurecounts/{sample}/count/{sample}_featurecountslnc.cnt" 
    output:
        "featurecounts/final_count/{sample}_featurecounts.cnt"
    shell:
        """
          cat {input} > {output}
        """

rule filter:
    input:
        "featurecounts/final_count/{sample}_featurecounts.cnt"
    output:
        "featurecounts/filtered/{sample}.counts"
    shell:
        """
          awk '{{print $1 "\t" $7}}' {input} > {output} 
        """  

#rule HTSeq_run:
#    input:
#        fastq_input("reads/trimmed/{sample}-R1-trimmed.fq.gz"),
#        bam="star/{sample}/{sample}.Aligned.sortedByCoord.out.bam"
#    output:
#        "star/{sample}/count/{sample}_HTSeqcounts.cnt"
#    conda:
#        "../envs/htseq.yaml"
#    log:
#        "star/{sample}/log/{sample}_htseq_count.log"
#    params:
#         gtf=resolve_single_filepath(*references_abs_path(ref='references'),
#                                    config.get("genes_gtf")),
#         strand=config['strand'],
#    shell:
#         "htseq-count "
#         "-m intersection-nonempty "
#        "--stranded={params.strand} "
#         "--idattr gene_id "
#         "-r pos "
#        "-f bam "
#         "{input.bam} {params.gtf} > {output} 2> {log}"