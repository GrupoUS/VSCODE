import { cn } from "@/lib/utils";
import React from "react";

/**
 * Interface que define as propriedades do componente UserProfileCard
 * @interface UserProfileCardProps
 */
export interface UserProfileCardProps {
  /** URL da imagem do avatar do usuário */
  avatarUrl: string;
  /** Nome completo do usuário */
  name: string;
  /** Nome de usuário (ex: @usuario) */
  username: string;
  /** Biografia curta do usuário */
  bio: string;
  /** Array de estatísticas do usuário (ex: seguidores, seguindo) */
  stats: Array<{ label: string; value: number }>;
  /** Controla a exibição do indicador de status online */
  isOnline?: boolean;
  /** Classes CSS adicionais para customização */
  className?: string;
}

/**
 * Componente UserProfileCard - Exibe informações de perfil de usuário
 * @component
 * @param {UserProfileCardProps} props - Propriedades do componente
 * @returns {JSX.Element} Componente UserProfileCard
 */
const UserProfileCard: React.FC<UserProfileCardProps> = ({
  avatarUrl,
  name,
  username,
  bio,
  stats,
  isOnline = false,
  className,
}) => {
  return (
    <div
      className={cn(
        "rounded-lg border bg-card text-card-foreground shadow-sm p-6",
        className
      )}
    >
      <div className="flex items-start space-x-4">
        {/* Avatar com indicador de status online */}
        <div className="relative">
          <img
            src={avatarUrl}
            alt={`Avatar de ${name}`}
            className="w-16 h-16 rounded-full object-cover"
          />
          {isOnline && (
            <span className="absolute bottom-0 right-0 w-3 h-3 bg-green-500 rounded-full border-2 border-white" />
          )}
        </div>

        {/* Informações do usuário */}
        <div className="flex-1 space-y-1">
          <h3 className="text-lg font-semibold">{name}</h3>
          <p className="text-sm text-muted-foreground">{username}</p>
          <p className="text-sm">{bio}</p>
        </div>
      </div>

      {/* Estatísticas */}
      <div className="mt-6 grid grid-cols-3 gap-4">
        {stats.map((stat, index) => (
          <div key={index} className="text-center">
            <p className="text-2xl font-bold">{stat.value}</p>
            <p className="text-sm text-muted-foreground">{stat.label}</p>
          </div>
        ))}
      </div>
    </div>
  );
};

export default UserProfileCard;
