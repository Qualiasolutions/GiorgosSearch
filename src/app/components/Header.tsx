import { Menu, Moon, Sun, Home, Search, Globe, Library, FolderClosed, Download, Settings, User, BookOpen, Terminal, Brain } from 'lucide-react';
import { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import Image from 'next/image';

interface HeaderProps {
  toggleSidebar?: () => void;
}

export default function Header({ toggleSidebar }: HeaderProps) {
  const [theme, setTheme] = useState<'light' | 'dark'>('dark');
  const [activeItem, setActiveItem] = useState<string>('home');
  
  useEffect(() => {
    // Force dark theme for consistent experience
    document.documentElement.classList.add('dark');
  }, []);

  const menuItems = [
    { id: 'home', label: 'Home', icon: Home },
    { id: 'discover', label: 'Discover', icon: Search },
    { id: 'spaces', label: 'Spaces', icon: FolderClosed },
    { id: 'library', label: 'Library', icon: Library },
    { id: 'knowledge', label: 'Knowledge', icon: BookOpen },
  ];

  const sidebarVariants = {
    hidden: { x: -20, opacity: 0 },
    visible: { 
      x: 0, 
      opacity: 1,
      transition: {
        duration: 0.3,
        when: "beforeChildren",
        staggerChildren: 0.1
      }
    }
  };

  const itemVariants = {
    hidden: { x: -20, opacity: 0 },
    visible: { x: 0, opacity: 1 }
  };
  
  return (
    <div className="flex flex-col h-screen">
      {/* Sidebar */}
      <motion.div 
        initial="hidden"
        animate="visible"
        variants={sidebarVariants}
        className="fixed top-0 left-0 h-full w-60 bg-qualia-darker border-r border-qualia-border flex flex-col"
      >
        <div className="p-4 flex items-center gap-2">
          <div className="relative w-8 h-8">
            <motion.div 
              whileHover={{ scale: 1.1 }}
              whileTap={{ scale: 0.95 }}
              className="w-8 h-8 rounded-full bg-black flex items-center justify-center text-white font-bold shadow-glow overflow-hidden"
            >
              <Image 
                src="/images/Untitled+design+-+2025-01-19T070746.544.png"
                alt="Tzironis Logo"
                width={24}
                height={24}
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
            </motion.div>
          </div>
          <h1 className="text-xl font-semibold text-white gradient-text">Tzironis Business Suite</h1>
        </div>
        
        <div className="mt-6 px-2">
          <motion.button 
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            className="w-full flex items-center gap-3 px-4 py-2 rounded-lg text-sm text-white bg-gradient-to-r from-qualia-primary to-qualia-accent hover:opacity-90 transition-all shadow-md"
          >
            <span className="text-sm font-medium">New Thread</span>
          </motion.button>
        </div>
        
        <nav className="mt-8 px-2">
          <ul className="space-y-1">
            {menuItems.map((item) => (
              <motion.li key={item.id} variants={itemVariants}>
                <motion.a 
                  href="#" 
                  className={`flex items-center gap-3 px-4 py-2 rounded-lg ${
                    activeItem === item.id 
                      ? 'text-white bg-qualia-secondary/70 border-l-2 border-qualia-accent' 
                      : 'text-gray-400 hover:bg-qualia-secondary/50 hover:text-white'
                  } transition-all duration-200`}
                  onClick={() => setActiveItem(item.id)}
                  whileHover={{ x: 5 }}
                  whileTap={{ scale: 0.98 }}
                >
                  <item.icon className="w-5 h-5" />
                  <span className="text-sm font-medium">{item.label}</span>
                </motion.a>
              </motion.li>
            ))}
          </ul>

          <div className="mt-8 pt-4 border-t border-qualia-border">
            <h3 className="px-4 text-xs font-semibold text-gray-500 uppercase tracking-wider">Insights</h3>
            <ul className="mt-2 space-y-1">
              <motion.li variants={itemVariants}>
                <a href="#" className="flex items-center gap-3 px-4 py-2 rounded-lg text-gray-400 hover:bg-qualia-secondary/50 hover:text-white transition-all duration-200">
                  <Brain className="w-5 h-5" />
                  <span className="text-sm font-medium">AI Models</span>
                </a>
              </motion.li>
              <motion.li variants={itemVariants}>
                <a href="#" className="flex items-center gap-3 px-4 py-2 rounded-lg text-gray-400 hover:bg-qualia-secondary/50 hover:text-white transition-all duration-200">
                  <Terminal className="w-5 h-5" />
                  <span className="text-sm font-medium">Advanced</span>
                </a>
              </motion.li>
            </ul>
          </div>
        </nav>
        
        <div className="mt-auto p-4">
          <div className="flex flex-col gap-2">
            <motion.button 
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              className="w-full flex items-center justify-center gap-2 px-4 py-2 rounded-lg text-sm text-gray-300 hover:bg-qualia-secondary/70 hover:text-white transition-all duration-200"
            >
              <Download className="w-4 h-4" />
              <span className="text-sm font-medium">Download App</span>
            </motion.button>
            
            <div className="flex items-center gap-2 mt-2 pt-2 border-t border-qualia-border">
              <motion.button 
                whileHover={{ scale: 1.1 }}
                whileTap={{ scale: 0.9 }}
                className="p-2 rounded-full bg-qualia-secondary/70 text-gray-400 hover:text-white hover:bg-qualia-secondary transition-all duration-200"
              >
                <Settings className="w-4 h-4" />
              </motion.button>
              
              <motion.button 
                whileHover={{ scale: 1.1 }}
                whileTap={{ scale: 0.9 }}
                className="p-2 rounded-full bg-qualia-secondary/70 text-gray-400 hover:text-white hover:bg-qualia-secondary transition-all duration-200"
              >
                <User className="w-4 h-4" />
              </motion.button>
            </div>
          </div>
        </div>
      </motion.div>
      
      {/* Main content header */}
      <header className="pl-60 w-full z-10 bg-qualia-dark/80 backdrop-blur-md border-b border-qualia-border sticky top-0">
        <div className="flex justify-between items-center p-4">
          <div className="flex items-center">
            <motion.button 
              whileHover={{ scale: 1.1 }}
              whileTap={{ scale: 0.9 }}
              className="p-2 rounded-md hover:bg-qualia-secondary/70 text-gray-400 hover:text-white transition-all duration-200"
            >
              <Globe className="w-5 h-5" />
            </motion.button>
          </div>
          
          <div className="flex items-center gap-2">
            <motion.button 
              whileHover={{ scale: 1.1 }}
              whileTap={{ scale: 0.9 }}
              className="p-2 rounded-md hover:bg-qualia-secondary/70 text-gray-400 hover:text-white transition-all duration-200"
              onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}
            >
              {theme === 'dark' ? <Sun className="w-5 h-5" /> : <Moon className="w-5 h-5" />}
            </motion.button>
          </div>
        </div>
      </header>
    </div>
  );
} 