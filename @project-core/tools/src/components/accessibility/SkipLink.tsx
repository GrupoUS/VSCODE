"use client";

import { useAccessibility } from '@/hooks/useAccessibility';

interface SkipLinkProps {
  href?: string;
  children?: React.ReactNode;
  className?: string;
}

export function SkipLink({ 
  href = "#main-content", 
  children = "Pular para o conteúdo principal",
  className = ""
}: SkipLinkProps) {
  const { focusElement } = useAccessibility();

  const handleClick = (e: React.MouseEvent) => {
    e.preventDefault();
    focusElement(href);
  };

  return (
    <a
      href={href}
      onClick={handleClick}
      className={`
        skip-link
        absolute -top-10 left-4 z-50
        bg-primary text-primary-foreground
        px-4 py-2 rounded-md
        font-medium text-sm
        transition-all duration-200
        focus:top-4
        ${className}
      `}
      style={{
        clipPath: 'inset(50%)',
        position: 'absolute',
        overflow: 'hidden',
        whiteSpace: 'nowrap',
        width: '1px',
        height: '1px',
      }}
      onFocus={(e) => {
        e.target.style.clipPath = 'none';
        e.target.style.width = 'auto';
        e.target.style.height = 'auto';
        e.target.style.overflow = 'visible';
        e.target.style.whiteSpace = 'normal';
      }}
      onBlur={(e) => {
        e.target.style.clipPath = 'inset(50%)';
        e.target.style.width = '1px';
        e.target.style.height = '1px';
        e.target.style.overflow = 'hidden';
        e.target.style.whiteSpace = 'nowrap';
      }}
    >
      {children}
    </a>
  );
}

export default SkipLink;
