clean:
	@vagrant destroy --force

test:
	for i in "validator" "explorer" "moc" "bootnode" "netstat"; do \
		echo "Verifying $$i..\n"; \
		vagrant up $$i; \
		vagrant destroy --force $$i; \
		echo "Done $$i verification\n"; \
	done
