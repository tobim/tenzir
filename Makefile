
INTERNAL := caf vast core
EXTERNAL := $(filter-out $(INTERNAL), $(MAKECMDGOALS))

caf:
	$(MAKE) -f Makefile.caf $(EXTERNAL)

vast: caf
	$(MAKE) -f Makefile.vast $(EXTERNAL)

core: vast
	$(MAKE) -f Makefile.core $(EXTERNAL)

.PHONY: $(INTERNAL) $(EXTERNAL)
