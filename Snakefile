
#qiime dada2 denoise-paired --i-demultiplexed-seqs demux-paired-end.qza --p-trim-left-f 0 --p-trim-left-r 0 --p-trunc-len-f 260 --p-trunc-len-r XXX --output-dir #dada_denoised

#cd dada_denoised
#qiime feature-table tabulate-seqs --i-data representative_sequences.qza --o-visualization representative_sequences.qzv
#qiime metadata tabulate --m-input-file denoising_stats.qza --o-visualization denoising_stats.qzv
#qiime feature-table summarize --i-table table.qza --o-visualization table.qzv


#qiime phylogeny align-to-tree-mafft-fasttree --i-sequences representative_sequences.qza --o-alignment aligned-rep-seqs.qza --o-masked-alignment masked-aligned-rep-#seqs.qza --o-tree unrooted-tree.qza --o-rooted-tree rooted-tree.qza

MY_PATH="opidata"
DADA_d = "dada"


"""
  891  pip uninstall scikit-learn

  893  pip install scikit-learn==0.21.2
  894  pip gneiss -U
  895  pip install gneiss -U
  896  pip list
  897  qiime feature-classifier classify-sklearn --i-classifier gg_13_9_99_classifier.qza --i-reads dada/representative_sequences.qza --o-classification dada/taxonomy.qza

  900  qiime metadata tabulate --m-input-file taxonomy.qza --o-visualization taxonomy.qzv
  901  qiime metadata tabulate --m-input-file dada/taxonomy.qza --o-visualization dada/taxonomy.qzv


"""

rule rdp_classifier:
	input:
		"gg-13-8-99-nb-classifier.qza",		
		DADA_d + "/representative_sequences.qza"
	output:
		DADA_d + "/taxonomy.qza"
	log: 
		"logs/rdp_classifier.log"
	benchmark:
		"benchmarks/rdp_classifier.tsv"
	shell:
		"qiime feature-classifier classify-sklearn --i-classifier {input[0]} --i-reads {input[1]} --o-classification {output} > {log}"
		





"""  
comments
rule tree:
	input:
		DADA_d + "/representative_sequences.qza"
	output:
		DADA_d + "/tree/aligned-rep-seqs.qza",
		DADA_d + "/tree/masked-aligned-rep-seqs.qza",
		DADA_d + "/tree/unrooted-tree.qza",
		DADA_d + "/tree/rooted-tree.qza"
	shell:
		"qiime phylogeny align-to-tree-mafft-fasttree --i-sequences {input} --o-alignment {output[0]} --o-masked-alignment {output[1]} --o-tree {output[2]} --o-rooted-tree {output[3]}"



rule tabulate_feature:
	input:
		DADA_d + "/representative_sequences.qza",
		DADA_d + "/denoising_stats.qza",
		DADA_d + "/table.qza"
	output:
		DADA_d + "/representative_sequences.qzv",
		DADA_d + "/denoising_stats.qzv",
		DADA_d + "/table.qzv"
	shell:
		strich
		qiime feature-table tabulate-seqs --i-data {input[0]} --o-visualization {output[0]}
		qiime metadata tabulate --m-input-file {input[1]} --o-visualization {output[1]}
		qiime feature-table summarize --i-table {input[2]} --o-visualization {output[2]}
		strich
		

rule denoise:
	input:
		MY_PATH + "/demux-paired-end.qza"
	output:
		directory(DADA_d)
	shell:
		"qiime dada2 denoise-paired --i-demultiplexed-seqs {input} --p-trim-left-f 0 --p-trim-left-r 0 --p-trunc-len-f 260 --p-trunc-len-r 260 --output-dir {output}"
""" 
