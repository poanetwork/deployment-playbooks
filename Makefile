clean:
	@vagrant destroy --force

test:
	for i in  "explorer" "moc" "bootnode" ; do \
		echo "Verifying $$i..\n"; \
		vagrant up $$i || exit 1; \
		vagrant destroy --force $$i; \
		echo "Done $$i verification\n"; \
	done
