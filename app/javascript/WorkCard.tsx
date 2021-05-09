import React, { useState } from 'react';
import { Badge, Card, Image, OverlayTrigger, Tooltip } from 'react-bootstrap';
import { faExternalLinkAlt } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Jissaku, User, Work } from 'types';
import WorkTweetButton from 'WorkTweetButton';
import WorkVoteButton from 'WorkVoteButton';

type Props = {
  work: Work;
  currentUser?: User;
};

function isJissaku(work: Work): work is Jissaku {
  return 'score' in work;
}

const WorkCard: React.FC<Props> = ({ work, currentUser }: Props) => {
  const [voters, setVoters] = useState<User[]>(work.voters);

  function handleVotersUpdated(voters: User[]) {
    work.voters = voters;
    setVoters(voters);
  }

  return (
    <Card className="mb-3" id={`work-${work.id}`}>
      <Card.Body>
        <Card.Text className="d-flex justify-content-between align-items-start mb-1">
          {work.kadai ? (
            <a href={`/${work.kadai.year}/${work.kadai.round}`} className="link-secondary">
              {work.kadai.year} 第{work.kadai.round}回
            </a>
          ) : (
            <a href={`/students/${work.student.genron_sf_id || work.student.id}`} className="link-secondary">
              {work.student.name}
            </a>
          )}

          {isJissaku(work) && work.prize ? (
            <Badge bg="success">{work.prize.title}</Badge>
          ) : isJissaku(work) && work.score > 0 ? (
            <Badge pill bg="success">
              {work.score}
            </Badge>
          ) : work.selected ? (
            <Badge bg="info">選出</Badge>
          ) : null}
        </Card.Text>
        <Card.Title>
          <a href={work.url} className="link-dark text-decoration-none" target="_blank" rel="noreferrer">
            {work.title}
          </a>
        </Card.Title>
        <Card.Text>
          <a href={work.url} className="link-secondary" target="_blank" rel="noreferrer">
            <FontAwesomeIcon icon={faExternalLinkAlt} /> {new URL(work.url).hostname}
          </a>
        </Card.Text>
        <Card.Text as="ul" className="list-inline">
          {voters.map((voter) => (
            <li key={voter.twitter_id} className="list-inline-item mr-0">
              <OverlayTrigger
                overlay={<Tooltip id={`${work.id}-${voter.twitter_id}`}>{voter.twitter_screen_name}</Tooltip>}
              >
                <a href={`https://twitter.com/${voter.twitter_screen_name}`} target="_blank" rel="noreferrer">
                  <Image src={voter.image_url} roundedCircle width={24} height={24} className="border"></Image>
                </a>
              </OverlayTrigger>
            </li>
          ))}
        </Card.Text>
        <WorkVoteButton
          workId={work.id}
          isJissaku={isJissaku(work)}
          isVoted={currentUser ? voters.some((voter) => voter.twitter_id === currentUser.twitter_id) : false}
          votesCount={voters.length}
          isLoggedIn={!!currentUser}
          handleVotersUpdated={handleVotersUpdated}
        />{' '}
        <WorkTweetButton work={work} isJissaku={isJissaku(work)} />
      </Card.Body>
    </Card>
  );
};

export default WorkCard;
