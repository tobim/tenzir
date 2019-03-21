
INTERNAL := broker caf vast tenzir
EXTERNAL := $(filter-out $(INTERNAL), $(MAKECMDGOALS))

broker:
	$(MAKE) -f Makefile.broker $(EXTERNAL)

caf:
	$(MAKE) -f Makefile.caf $(EXTERNAL)

vast:
	$(MAKE) -f Makefile.vast $(EXTERNAL)

tenzir:
	$(MAKE) -f Makefile.tenzir $(EXTERNAL)

scrub:
	rm -rf ~/build/broker
	rm -rf ~/build/caf
	rm -rf ~/build/vast
	rm -rf ~/build/tenzir
	rm -rf ~/install/broker
	rm -rf ~/install/caf
	rm -rf ~/install/vast
	rm -rf ~/install/tenzir

.PHONY: $(INTERNAL) $(EXTERNAL)
