                    <div className="mb-6 mx-auto">
                      <div className="w-24 h-24 rounded-2xl bg-black flex items-center justify-center text-white font-bold text-4xl shadow-glow mx-auto mb-4 overflow-hidden">
                        <Image 
                          src="/images/Untitled+design+-+2025-01-19T070746.544.png"
                          alt="Tzironis Logo"
                          width={64}
                          height={64}
                          priority
                          onError={(e) => {
                            // Fallback to a text representation if image fails to load
                            const target = e.target as HTMLElement;
                            if (target) {
                              target.style.display = 'none';
                              const parent = target.parentElement;
                              if (parent) {
                                parent.textContent = 'TZ';
                              }
                            }
                          }}
                        />
                      </div>
                      <div className="w-48 h-2 bg-gradient-to-r from-qualia-primary to-qualia-accent rounded-full mx-auto opacity-50" />
                    </div>
                    
                    <h1 className="text-5xl font-bold gradient-text mb-4">
                      Γεια σου Tzironis!
                    </h1>
                    
                    <p className="text-gray-400 text-lg mb-12 max-w-xl mx-auto">
                      Είμαι η Qualia, η προσωπική σου βοηθός. Τι θα ήθελες να αναζητήσουμε σήμερα;
                    </p> 