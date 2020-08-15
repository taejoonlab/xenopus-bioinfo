#!/usr/bin/env python3

filename_raw = 'ERCC92.raw.fa'
filename_out = 'ERCC92.annot.fa'

annot_list = dict()
f_annot = open('ERCC_Control_Analysis.txt', 'r')
h_annot = f_annot.readline()
for line in f_annot:
    tokens = line.strip().split("\t")
    ercc_id = tokens[1]
    subgroup = tokens[2]
    conc_mix1 = float(tokens[3])
    conc_mix2 = float(tokens[4])
    annot_list[ercc_id] = '%s|%s|%d|%d' %\
                          (ercc_id, subgroup, conc_mix1, conc_mix2)
f_annot.close()

f_out = open(filename_out, 'w')
f_raw = open(filename_raw, 'r')
for line in f_raw:
    if line.startswith('>'):
        ercc_id = line.strip().lstrip('>')
        f_out.write('>%s\n' % (annot_list[ercc_id]))
    else:
        f_out.write('%s\n' % line.strip())
f_raw.close()
f_out.close()
