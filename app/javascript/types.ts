export type Kadai = {
  id: number;
  url: string;
  year: number;
  round: number;
  title: string;
  author: string;
  kougai_deadline: string;
  jissaku_deadline: string;
};

export type Student = {
  id: number;
  url: string;
  genron_sf_id: string | null;
  name: string;
  description: string | null;
};

export type User = {
  twitter_id: number;
  twitter_screen_name: string;
  image_url: string;
};

export type Jissaku = {
  id: number;
  url: string;
  genron_sf_id: number | null;
  title: string;
  student: Student;
  selected: boolean;
  score: number;
  voters: User[];
  kadai?: Kadai;
  prize?: {
    title: string;
  };
};

export type Kougai = {
  id: number;
  url: string;
  genron_sf_id: number | null;
  title: string;
  student: Student;
  selected: boolean;
  voters: User[];
  kadai?: Kadai;
};

export type Work = Jissaku | Kougai;

export type ScoreTable = {
  student: string;
  scores: number[];
}[];
