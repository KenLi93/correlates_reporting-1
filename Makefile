## immuno                 : builds immunogenicity exploratory analyses
immuno:
	$(MAKE) -k -C immuno_tabular all
	$(MAKE) -k -C immuno_graphical all

## cor                    : builds Correlates of Risk analyses
cor:
	$(MAKE) -k -C cor_graphical all
	$(MAKE) -k -C cor_coxph all
	$(MAKE) -k -C cor_threshold all
	$(MAKE) -k -C cor_surrogates all
	$(MAKE) -k -C cor_nonpar all

## cop                    : builds Correlates of Protection analyses
cop:
	$(MAKE) -k -C cop_prinstrat all
	$(MAKE) -k -C cop_controlled all
	$(MAKE) -k -C cop_stochastic all
	$(MAKE) -k -C cop_mediation all

## style                  : re-styles the codebase for consistent formatting
style:
	Rscript -e "styler::style_dir(filetype = 'rmd')"

## book                   : builds the CoVPN report
book:
	sh ./_build.sh

## type 'make help' to show all make commands
help: Makefile
	@sed -n 's/^##//p' $<

.PHONY: style book
