
INTERNAL := broker caf vast core
EXTERNAL := $(filter-out $(INTERNAL), $(MAKECMDGOALS))

broker:
	$(MAKE) -f Makefile.broker $(EXTERNAL)

caf:
	$(MAKE) -f Makefile.caf $(EXTERNAL)

vast:
	$(MAKE) -f Makefile.vast $(EXTERNAL)

core:
	$(MAKE) -f Makefile.core $(EXTERNAL)

.PHONY: $(INTERNAL) $(EXTERNAL)
