# The following line is commented out for now because gnuplottex does not
# support alternate output directory. See issue in gnuplottex issue-tracker:
# https://github.com/larskotthoff/gnuplottex/issues/16
# $out_dir = '.build';

# The following is to avoid infinite recompilation with latexmk. This problem
# is somehow related to the gnuplottex package.  Auto-generated .eps files
# contains timestamped 'CreationDate' references which causes latexmk to
# falsely believe that the user has updated a source file every time the
# sources are compiled.
# Inspired by answer on LaTeX StackExchange:
# https://tex.stackexchange.com/q/579396
$hash_calc_ignore_pattern{'eps'} = '^.*CreationDate';
