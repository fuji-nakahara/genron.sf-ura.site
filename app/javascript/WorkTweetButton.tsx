import React from 'react';
import Button from 'react-bootstrap/Button';
import { faTwitter } from '@fortawesome/free-brands-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Work } from 'types';

type Props = {
  work: Work;
  isJissaku: boolean;
};

const WorkTweetButton: React.FC<Props> = ({ work, isJissaku }: Props) => {
  const tweetParams = new URLSearchParams();
  tweetParams.append('text', `【${isJissaku ? '実作' : '梗概'}】 ${work.student.name}『${work.title}』`);
  tweetParams.append('url', work.url);
  tweetParams.append('hashtags', work.genron_sf_id ? 'SF創作講座' : '裏SF創作講座');

  const tweetUrl = new URL('https://twitter.com/intent/tweet');
  tweetUrl.search = tweetParams.toString();

  return (
    <Button href={tweetUrl.toString()} variant="outline-primary" size="sm" target="_blank">
      <FontAwesomeIcon icon={faTwitter} /> コメントする
    </Button>
  );
};

export default WorkTweetButton;
