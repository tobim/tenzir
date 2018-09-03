
INTERNAL := caf vast core
EXTERNAL := $(filter-out $(INTERNAL), $(MAKECMDGOALS))

caf:
	$(MAKE) -f Makefile.caf $(EXTERNAL)

vast:
	$(MAKE) -f Makefile.vast $(EXTERNAL)

core:
	$(MAKE) -f Makefile.core $(EXTERNAL)

.PHONY: $(INTERNAL) $(EXTERNAL)
