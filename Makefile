
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

scrub:
	rm -rf ~/build/broker
	rm -rf ~/build/caf
	rm -rf ~/build/vast
	rm -rf ~/build/core
	rm -rf ~/install/broker
	rm -rf ~/install/caf
	rm -rf ~/install/vast
	rm -rf ~/install/core

.PHONY: $(INTERNAL) $(EXTERNAL)
