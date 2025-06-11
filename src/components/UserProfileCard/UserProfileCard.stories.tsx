import type { Meta, StoryObj } from "@storybook/react";
import UserProfileCard from "./index";

const meta: Meta<typeof UserProfileCard> = {
  title: "Components/UserProfileCard",
  component: UserProfileCard,
  parameters: {
    layout: "centered",
  },
  tags: ["autodocs"],
};

export default meta;
type Story = StoryObj<typeof UserProfileCard>;

/**
 * Exemplo padrão do UserProfileCard com todas as propriedades
 */
export const Default: Story = {
  args: {
    avatarUrl: "https://github.com/shadcn.png",
    name: "João Silva",
    username: "@joaosilva",
    bio: "Desenvolvedor Full Stack apaixonado por React e TypeScript",
    stats: [
      { label: "Seguidores", value: 1234 },
      { label: "Seguindo", value: 567 },
      { label: "Posts", value: 89 },
    ],
    isOnline: false,
  },
};

/**
 * Exemplo do UserProfileCard com status online
 */
export const Online: Story = {
  args: {
    ...Default.args,
    isOnline: true,
  },
};

/**
 * Exemplo do UserProfileCard com bio longa
 */
export const LongBio: Story = {
  args: {
    ...Default.args,
    bio: "Desenvolvedor Full Stack com mais de 5 anos de experiência em React, TypeScript, Node.js e Python. Apaixonado por criar interfaces intuitivas e experiências de usuário excepcionais.",
  },
};

/**
 * Exemplo do UserProfileCard com diferentes estatísticas
 */
export const CustomStats: Story = {
  args: {
    ...Default.args,
    stats: [
      { label: "Projetos", value: 42 },
      { label: "Contribuições", value: 789 },
      { label: "Stars", value: 123 },
    ],
  },
};
