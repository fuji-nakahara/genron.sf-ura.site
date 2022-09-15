import Rails from '@rails/ujs';
import React, { useState } from 'react';
import { Badge, Button, Modal } from 'react-bootstrap';
import { faTwitter } from '@fortawesome/free-brands-svg-icons';
import { faThumbsUp } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { User } from 'types';

type Props = {
  workId: number;
  isJissaku: boolean;
  isVoted: boolean;
  votesCount: number;
  isLoggedIn: boolean;
  handleVotersUpdated: (voters: User[]) => void;
};

const WorkVoteButton: React.FC<Props> = ({
  workId,
  isJissaku,
  isVoted,
  votesCount,
  isLoggedIn,
  handleVotersUpdated,
}: Props) => {
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  async function handleOnClick() {
    if (!isLoggedIn) {
      setErrorMessage('ログインしてください');
      return;
    }

    setIsLoading(true);

    const endpoint = `/works/${workId}/vote`;
    const method = isVoted ? 'DELETE' : 'POST';
    const headers = new Headers({ 'X-Requested-With': 'XMLHttpRequest' });
    const token = Rails.csrfToken();
    if (token) {
      headers.append('X-CSRF-Token', token);
    }

    try {
      const response = await fetch(endpoint, {
        method: method,
        credentials: 'same-origin',
        headers: headers,
      });
      if (response.ok) {
        const voters = await response.json();
        handleVotersUpdated(voters);
      } else if (response.status === 400) {
        const error = await response.json();
        setErrorMessage(error.errors.join('<br>'));
      } else {
        throw new Error(`Failed ${method} ${endpoint} ${response.status} (${response.statusText})`);
      }
    } finally {
      setIsLoading(false);
    }
  }

  function handleOnHide() {
    setErrorMessage(null);
  }

  return (
    <>
      <Button
        variant={`outline-${isJissaku ? 'success' : 'info'}`}
        size="sm"
        disabled={isLoading}
        active={isVoted}
        onClick={handleOnClick}
      >
        <FontAwesomeIcon icon={faThumbsUp} /> {isVoted ? '取り消す' : '投票する'}{' '}
        <Badge pill bg="light" text="dark">
          {votesCount}
        </Badge>
      </Button>

      <Modal show={!!errorMessage} onHide={handleOnHide}>
        <Modal.Header closeButton>
          <Modal.Title>エラー</Modal.Title>
        </Modal.Header>
        <Modal.Body>{errorMessage}</Modal.Body>
        {!isLoggedIn && (
          <Modal.Footer>
            <Button href={`/auth/twitter2?origin=${location.pathname}`} data-method="post">
              <FontAwesomeIcon icon={faTwitter} /> Twitter でログインする
            </Button>
          </Modal.Footer>
        )}
      </Modal>
    </>
  );
};

export default WorkVoteButton;
