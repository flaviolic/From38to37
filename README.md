# From38to37
A program to map slices from GRCh38 assemblies to GRCh37 assembly using ENSEMBL API

Usage:
```
From38to37.pl --chromosome=chromosome --start=start --end=end

From38to37.pl --help
    --chromosome / -c   Chromosome name.
    --start / -s    Chromosome region start
    --end / -e  Chromosome region end
    --help / -h To see this text.
```
Example usage:
```
perl ./From38to37.pl -c 10 -s 25000 -e 30000
```

### Copyright 2019 Flavio Licciulli
