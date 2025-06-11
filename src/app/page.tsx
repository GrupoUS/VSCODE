import UserProfileCard from "@/components/UserProfileCard";

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <UserProfileCard
        avatarUrl="https://github.com/shadcn.png"
        name="João Silva"
        username="@joaosilva"
        bio="Desenvolvedor Full Stack apaixonado por React e TypeScript"
        stats={[
          { label: "Seguidores", value: 1234 },
          { label: "Seguindo", value: 567 },
          { label: "Posts", value: 89 },
        ]}
        isOnline={true}
      />
    </main>
  );
}
